import System
import System.IO

class Message:
    [Getter(Path)] _Path as string
    [Getter(Subject)] _Subject as string
    [Getter(Body)] _Body as string
    [Getter(IsSpam)] _IsSpam as bool
    
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

    def Train(msg as Message):
        words = msg.Body.Split()
        for word in words:
            pass
            
        NumMessages += 1
        if msg.IsSpam:
            NumSpamMessages += 1
    
    def Update():
        for term in Terms.Keys:
            
    
    def Classify(msg as Message) as bool:
        if not IsUpdated:
            Update()
    
        bestScore = 0.0
        result = false
        for isSpam in (true, false):
            Ny = (NumSpamMessages if isSpam else (NumMessages - NumSpamMessages))
            prior = Ny /double(NumMessages)
            score = prior
            for term in msg.Tokens:
                score += Math.Log(CondProb[term][isSpam])
            
            if score > bestScore:
                bestScore = score
                result = isSpam
        return result

classifier = NaiveBayesClassifier()
       
# Train the classifier       
directory = "data/part3"
dirInfo = DirectoryInfo(directory)
files = dirInfo.GetFiles()
for f in files:
    m = Message(Path.Combine(directory, f.Name), f.Name.StartsWith("spmsg"))
    classifier.Train(m)
    
# Classify a few documents
directory = "data/part2"
dirInfo = DirectoryInfo(directory)
files = dirInfo.GetFiles()
for f in files:
    m = Message(Path.Combine(directory, f.Name), f.Name.StartsWith("spmsg"))
    isSpam = classifier.Classify(m)
    print isSpam == m.IsSpam