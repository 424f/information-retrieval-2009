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

input = null
while input != "quit":
	System.Console.Write("> ")
	input = System.Console.ReadLine()
	if input == "quit":	
		break
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