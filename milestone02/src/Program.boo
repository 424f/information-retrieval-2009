namespace IR

import Boo.Lang.Useful.IO
import System
import System.IO
import System.Collections.Generic

rs as RetrievalSystem
documentsProcessed = 0
termsProcessed = 0

def GetTicks() as double:
	return DateTime.Now.Ticks / 10000.0

def PrintProgress(sender as object, e as DocumentLoadedArgs):
	BarWidth = 20
	documentsProcessed += 1
	termsProcessed += e.NumTerms
	Console.Write("\r[")
	percent = cast(single, documentsProcessed) / rs.NumDocuments
	numBars = Math.Min(BarWidth, cast(int, percent * BarWidth))
	Console.Write("#" * numBars)
	if numBars < BarWidth:
		Console.Write(" " * (BarWidth - numBars))
	Console.Write("] Creating index (${documentsProcessed} / ${rs.NumDocuments} documents)")

print ""
print "AWESOME RETRIEVAL SYSTEM(TM) 2.0 BETA"
print "-------------------------------------"
print ""

rs = RetrievalSystem()
rs.DocumentLoaded += PrintProgress
rs.CreateIndex("data/TIME/Docs")
Console.WriteLine()

print ""
print "The power of the AWESOME RETRIEVAL SYSTEM is now at your fingertips."
print ""

input = null
while input != "quit":
	System.Console.Write("> ")
	input = System.Console.ReadLine()
	if input == "quit":	
		break
	if input == "plot":
		dirInfo = DirectoryInfo("data/TIME/Queries")
		
		relevantDocs = Dictionary[of String, List[of int]]()
		# load relevancy list
		rfile = Path.Combine(dirInfo.ToString(), "RelevancyLists.txt")
		rlines = File.ReadAllLines(rfile)
		
		for line in rlines:
			rdocs = line.Split()
			queryNumber = rdocs[0] as String
			relevantDocs[queryNumber] = List[of int]()
			for doc in rdocs[1:]:
				if doc != "":
					relevantDocs[queryNumber].Add(int.Parse(doc))
		
		
		files = dirInfo.GetFiles()
		for q in files:
			if q.Name == "RelevancyLists.txt":
				continue
				
			path = Path.Combine(dirInfo.ToString(), q.Name)
			query = File.ReadAllText(path)
			rslt = rs.ExecuteQuery(query)
			
			qnumber = q.Name[1:]
			relevantDocsFound = 0.0
			sw = StreamWriter("data/TIME/Queries/Plots/${q.Name}.dat")
			sw.WriteLine( "0 1")
			for entry as QueryResult in rslt:
				docNr = int.Parse(entry.Document.Title[3:])
				if relevantDocs.ContainsKey(qnumber):
					if docNr in relevantDocs[qnumber]:
						relevantDocsFound += 1
					recall = relevantDocsFound / relevantDocs[qnumber].Count
					precision = relevantDocsFound / (relevantDocs[qnumber].Count - relevantDocsFound)
					sw.WriteLine( "${recall} ${precision}")
			sw.Close()
			print "${q.Name} found ${relevantDocsFound}"

			
	else:
		result as List[of QueryResult]
		try:
			
			before = GetTicks()
			result = rs.ExecuteQuery(input, false)
			dt = GetTicks() - before
			print "${dt}ms "
			
			for entry in result:
				System.Console.Write(entry.Document.Title + " ")
				# We can now actually retrieve the content
				#print doc.ReadContent()
				#print "---"
			print ""
			print "Displayed ${result.Count} results"
		except e:
			print "***ERROR***", e
	print ""