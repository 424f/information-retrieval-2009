namespace DiagramTool

import IR
import System
import System.Collections.Generic
import System.IO

struct Point:
	Precision as double
	Recall as double
	MaxPrecision as double
	
	def constructor(r as double, p as double):
		Precision = p
		Recall = r
		MaxPrecision = p
		
	def constructor(p as Point, maxPrecision as double):
		Precision = p.Precision
		Recall = p.Recall
		MaxPrecision = maxPrecision

def WritePlotFile(path as string, plotName as string, titles as (string)):
	out = StreamWriter(path)
	out.Write("""
	set terminal png
	set output '""" + plotName + """.png'
	set ylabel 'Precision'
	set xlabel 'Recall'
	set xrange [-0.1:1.1]
	set yrange [-0.1:1.1]
	""")
	out.Write("plot ")
	for i in range(titles.Length):
		out.Write("'${plotName}.dat' index ${i} using 1:2 w linespoints lw 2 pt 5 title '${titles[i]}'")
		if i != titles.Length - 1:
			out.WriteLine(", \\")
	out.Close()

dirInfo = DirectoryInfo("data/TIME/Queries")
settingNames = ("Standard", "Stemming", "Stopword Elimination", "Stemming & Stopword Elimination")
retrievalSystems = List[of RetrievalSystem]()
dirs = ("GlobalQueryExpansion",)

rs = IR.RetrievalSystem()
rs.CreateIndex("data/TIME/Docs")
retrievalSystems.Add(rs)

rs = IR.RetrievalSystem()
rs.EnableStemming = true
rs.CreateIndex("data/TIME/Docs")
retrievalSystems.Add(rs)

rs = IR.RetrievalSystem()
rs.LoadStopwords("data/stopwords.txt")
rs.CreateIndex("data/TIME/Docs")
retrievalSystems.Add(rs)

rs = IR.RetrievalSystem()
rs.LoadStopwords("data/stopwords.txt")
rs.EnableStemming = true
rs.CreateIndex("data/TIME/Docs")
retrievalSystems.Add(rs)

relevantDocs = Dictionary[of string, List[of int]]()
# load relevancy list
rfile = Path.Combine(dirInfo.ToString(), "RelevancyLists.txt")
rlines = File.ReadAllLines(rfile)

for line in rlines:
	rdocs = line.Split()
	queryNumber = rdocs[0] as string
	relevantDocs[queryNumber] = List[of int]()
	for doc in rdocs[1:]:
		if doc != "":
			relevantDocs[queryNumber].Add(int.Parse(doc))

for dir in dirs:
	files = dirInfo.GetFiles()
	IO.Directory.CreateDirectory("data/TIME/Plots/${dir}")
	for q in files:
		if q.Name == "RelevancyLists.txt":
			continue
			
		path = Path.Combine(dirInfo.ToString(), q.Name)
		query = File.ReadAllText(path)
		
		qnumber = q.Name[1:]
		
		# Run for each retrieval system configuration
		WritePlotFile("data/TIME/Plots/${dir}/${q.Name}.gnuplot", q.Name, settingNames)
		sw = StreamWriter("data/TIME/Plots/${dir}/${q.Name}.dat")
		bias = 0.0 #-0.005 - 0.0025
		for rs as IR.RetrievalSystem in retrievalSystems:
			rs.EnableGlobalQueryExpansion = (dir == "GlobalQueryExpansion")
			localExpansion = (dir.StartsWith("LocalQueryExpansion"))
			alpha = 0.0
			if localExpansion:
				alpha = double.Parse(dir.Substring("LocalQueryExpansion".Length))
				print "Using alpha=${alpha}"
			
			bias += 0.00 #25
			if localExpansion:
				rslt = rs.ExecuteQueryWithLocalExpansion(query, true, alpha)
			else:
				rslt = rs.ExecuteQuery(query, true)
			
			relevantDocsFound = 0.0
			docsFound = 0.0
			
			interpolated = List[of Point]()
			interpolated.Add(Point(0.0, 1.0))
			for entry as QueryResult in rslt:
				docNr = int.Parse(entry.Document.Title[3:])
				if relevantDocs.ContainsKey(qnumber):
					if docNr in relevantDocs[qnumber]:
						relevantDocsFound += 1
					docsFound += 1
					recall = relevantDocsFound / relevantDocs[qnumber].Count
					precision = relevantDocsFound / docsFound
					interpolated.Add(Point(recall, precision))
		
			// Create interpolated plot	
			def findMax(recall as double):
				max = -1.0
				for x in interpolated:
					if x.Recall >= recall and x.Precision > max:
						max = x.Precision
				return max
			
			i = interpolated.Count - 1
			while i > 0:
				interpolated[i] = Point(interpolated[i-1], findMax(interpolated[i].Recall))
				/*if interpolated[i-1].MaxPrecision < interpolated[i].MaxPrecision:
					interpolated[i-1] = Point(interpolated[i-1], interpolated[i].MaxPrecision)*/
				i -= 1
		
			// Write plot file
			/*for p in interpolated:
				sw.WriteLine("${p.Recall} ${p.Precision}")
			sw.WriteLine()
			sw.WriteLine()*/
			
			lastP = 1.0
			lastR = 0.0
			sw.WriteLine("${bias} ${1.0+bias}")
			for i in range(interpolated.Count):
				p = interpolated[i]
				sw.WriteLine("${p.Recall+bias} ${p.MaxPrecision+bias}")
				/*if p.Recall != lastR or i == interpolated.Count - 1:
					sw.WriteLine("${lastR+bias} ${p.Precision+bias}")
					lastP = p.MaxPrecision
					lastR = p.Recall
					sw.WriteLine("${p.Recall+bias} ${p.Precision+bias}")*/
			sw.WriteLine()
			sw.WriteLine()
	
			/*bias += 0.0025
			for i in range(interpolated.Count):
				p = interpolated[i]
				sw.WriteLine("${p.Recall+bias} ${p.Precision+bias}")
	
			sw.WriteLine()
			sw.WriteLine()		*/
			
			print "${q.Name} found ${relevantDocsFound}, returned ${rslt.Count}"
		sw.Close()

print "Press any key to continue . . . "
Console.ReadKey(true)
