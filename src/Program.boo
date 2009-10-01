namespace IR

import System
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

processor = rs.CreateQueryProcessor()
input = null
while input != "quit":
	System.Console.Write("> ")
	input = System.Console.ReadLine()
	if input == "quit":	
		break
	elif input == "stats":
		# Size of the term-document matrix (assuming we had one)
		print "Term-document matrix size:"
		print "  ${rs.NumDocuments} x ${rs.NumTerms} = ${rs.NumDocuments*rs.NumTerms}"
		
		longestPostingList = rs.RetrieveDocumentsForTerm(0).Count 
		shortestPostingList = longestPostingList
		print "Number of 1s in this matrix:"
		numOnes = 0
		for i in range(rs.NumTerms):
			numDocuments = rs.RetrieveDocumentsForTerm(i).Count
			numOnes += numDocuments
			longestPostingList = Math.Max(longestPostingList, numDocuments)
			shortestPostingList = Math.Min(shortestPostingList, numDocuments)
		print "  ${numOnes} (which means ${cast(single, numOnes) / rs.NumDocuments / rs.NumTerms}%)"
		
		print "Longest posting list:"
		print "  ${longestPostingList} document(s) (that's quite a lot)"
		
		print "Shortest posting list:"
		print "  ${shortestPostingList} document(s)"
	else:
		result as List[of Document]
		try:
			for dir in (ParseDirection.ParseFromRight, ParseDirection.ParseFromLeft):
				query = QueryBuilder.Process(rs, input, dir)
				before = GetTicks()
				result = processor.ProcessQuery(query)
				dt = GetTicks() - before
				print "${dir}: ${dt}ms "
			
			for doc in result:
				System.Console.Write(doc.Title + " ")
				# We can now actually retrieve the content
				#print doc.ReadContent()
				#print "---"
			print ""
			print "Displayed ${result.Count} results"
		except e:
			print "***ERROR***", e
	print ""