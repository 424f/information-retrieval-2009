namespace IR

import System

rs as RetrievalSystem
documentsProcessed = 0
termsProcessed = 0

def PrintProgress(sender as object, e as DocumentLoadedArgs):
	documentsProcessed += 1
	termsProcessed += e.NumTerms
	Console.Write("\r")
	Console.Write("Processed ${documentsProcessed} / ${rs.NumDocuments} documents")

print ""
print "AWESOME RETRIEVAL SYSTEM 2.0 BETA"
print "---------------------------------"
print ""

rs = RetrievalSystem()
rs.DocumentLoaded += PrintProgress
rs.CreateIndex("data/TIME/Docs")
Console.WriteLine()

processor = rs.CreateQueryProcessor()
input = null
while input != "quit":
	System.Console.Write("> ")
	input = System.Console.ReadLine()
	if input != "quit":	
		query = QueryBuilder.Process(input)
		for doc in processor.ProcessQuery(query):
			print doc.Title
			# We can now actually retrieve the content
			#print doc.ReadContent()
			#print "---"
System.Console.ReadKey()