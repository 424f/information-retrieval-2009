import System
import System.IO
import System.Collections.Generic

class Message:
    [Getter(Path)] _Path as string
    [Getter(Subject)] _Subject as string
    [Getter(Body)] _Body as string
    [Getter(IsSpam)] _IsSpam as bool

    Tokens as (string):
        get:
            return regex("[\\t\\s]+").Split(Body)
    
    def constructor(path as string, isSpam as bool):
        _Path = path
        _IsSpam = isSpam
        
        lines = File.ReadAllLines(path)
        assert lines.Length == 3
        assert lines[1].Trim() == ""
        
        # Parse subject
        subjectTag = "Subject: "
        assert lines[0].StartsWith(subjectTag)
        _Subject = lines[0].Substring(subjectTag.Length)
        
        # Read body
        _Body = lines[2]
        
class NaiveBayesClassifier:
    # These values are used for prior
    NumSpamMessages = 0
    NumMessages = 0
    
    Terms = Dictionary[of string, int]()
    Messages = List[of Message]()
    Prior = Dictionary[of bool, double]()
    CondProb = Dictionary[of string, Dictionary[of bool, double]]()
    
    public Alpha as double
    
    IsUpdated = false

    def constructor():
        Alpha = 1.0
    
    def Train(msg as Message):
        Messages.Add(msg)
        for term in msg.Tokens:
            if not Terms.ContainsKey(term):
                Terms[term] = 0
            Terms[term] += 1
        NumMessages += 1
        if msg.IsSpam:
            NumSpamMessages += 1            
    
    def Update():
        // Extract vocabulary        
        for t in Terms.Keys:
            CondProb[t] = Dictionary[of bool, double]()
        
        for isSpam in (true, false):
            Ty = Dictionary[of string, int]()
            
            for msg in Messages:
                if msg.IsSpam != isSpam:
                    continue
            
                for term in msg.Tokens:
                    if not Ty.ContainsKey(term):
                        Ty[term] = 0
                    Ty[term] += 1
            
            divisor = 0.0
            for t in Terms.Keys:
                CondProb[t][isSpam] = (Ty[t] + 1 if Ty.ContainsKey(t) else 1)
                divisor += CondProb[t][isSpam]
                
            for t in Terms.Keys:
                CondProb[t][isSpam] = CondProb[t][isSpam] / divisor
                    
            Ny = (NumSpamMessages if isSpam else (NumMessages - NumSpamMessages))
            Prior[isSpam] = Ny / cast(double, NumMessages)
            
    
    def Classify(msg as Message) as bool:
        results = List[of double]()
        for isSpam in (true, false):
            score = Math.Log(Prior[isSpam])
            for term in msg.Tokens:
                if CondProb.ContainsKey(term):
                    score += Math.Log(CondProb[term][isSpam])
            results.Add(score)
        factor = results[0] / results[1]
        return factor <= Alpha

def Run():
    # Create a classifier for all the set combinations
    numSets = 10
    classifiers = array(NaiveBayesClassifier, numSets)
    for s in range(1, numSets + 1):
        Console.Out.Write("Creating classifier #${s}... ")
        # Train the classifier 
        classifier = NaiveBayesClassifier()
        for i in range(1, 11):      
            continue if i == s
            directory = "data/part${i}"
            dirInfo = DirectoryInfo(directory)
            files = dirInfo.GetFiles()
            for f in files:
                m = Message(Path.Combine(directory, f.Name), f.Name.StartsWith("spmsg"))
                classifier.Train(m)
        classifier.Update()
        classifiers[s-1] = classifier
        Console.Out.WriteLine("DONE!")
        
    plot = StreamWriter('roc')   
    recallPlot = StreamWriter('recall')
    start = 0.8
    end = 1.3
    steps = 10.0

    alpha = start
    while alpha < end:
        print "== Alpha ${alpha} =="
        for usedSet in range(1, numSets + 1):        
            # Classify a few documents
            classifier = classifiers[usedSet - 1]
            classifier.Alpha = alpha
            directory = "data/part${usedSet}"
            dirInfo = DirectoryInfo(directory)
            files = dirInfo.GetFiles()
            
            TP = 0.0
            FP = 0.0
            FN = 0.0
            TN = 0.0
            N = 0.0
            
            for f in files:
                m = Message(Path.Combine(directory, f.Name), f.Name.StartsWith("spmsg"))
                isSpam = classifier.Classify(m)
                
                if m.IsSpam:
                    if isSpam:
                        TP += 1.0
                    else:
                        FN += 1.0
                else:
                    if isSpam:
                        FP += 1.0
                    else:
                        TN += 1.0
                N += 1.0
            
            # Plot precision / recall 
            recallPlot.WriteLine("${TP / (TP + FN)} ${TP / (TP + FP)}")
            
            # Plot ROC
            plot.WriteLine("${FP / (FP + TN)} ${TP / (TP + FN)}")
        plot.WriteLine("")
        recallPlot.WriteLine("")
        alpha += (end - start) / steps
        
    plot.Close()
    recallPlot.Close()

Run()