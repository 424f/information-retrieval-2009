import System
import System.IO

class RetrievalSystem:
	protected Documents = List[of Document]()

	public def constructor(directory as string):
		dirInfo = DirectoryInfo(directory)
		files = dirInfo.GetFiles()
		for f in files:
			path = IO.Path.Combine(directory, f.Name)
			doc = Document(self, path)
			doc.Process()
			Documents.Add(doc)
			print "Loaded ${doc.Title} with ${doc.Terms.Count} terms."

	public def CreateQueryProcessor():
		return QueryProcessor(self)

class QueryProcessor(IQueryVisitor[of string]):
	protected RetrievalSystem as RetrievalSystem
	
	public def constructor(retrievalSystem as RetrievalSystem):
		RetrievalSystem = retrievalSystem

	public def VisitAndQuery(andQuery as object, val as string):
		pass
		
	public def VisitOrQuery(orQuery as object, val as string):
		pass
		
	public def VisitNotQuery(notQuery as object, val as string):
		pass

class Document:
	[Getter(RetrievalSystem)] _RetrievalSystem as RetrievalSystem
	"""The retrieval system to which this document belongs"""
	
	[Property(Title)] _Title as string
	"""This document's title"""
	
	[Property(Path)] _Path as string
	"""The path where this document is located"""
	
	[Getter(Terms)] _Terms = List[of string]()
	"""Terms that occur in this document"""
	
	public def constructor(retrievalSystem as RetrievalSystem, path as string):
		Path = path
	
	public def Process():
		lines = File.ReadAllLines(Path)
		for line in lines:
			words = line.Split((" ", ",", ".", "!", "?", "-"), StringSplitOptions.RemoveEmptyEntries)
			for word in words:
				_Terms.AddUnique(string.Intern(word))
		_Terms.Sort()
			
	public def ReadContent() as string:
		return File.ReadAllText(Path)

rs = RetrievalSystem("data/TIME/Docs")
System.Console.ReadKey()