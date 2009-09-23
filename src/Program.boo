namespace IR

import System
import System.IO
import System.Collections.Generic

class RetrievalSystem:
	protected Documents = List[of Document]()
	protected Index = Dictionary[of string, List[of Document]]()

	public def constructor(directory as string):
		dirInfo = DirectoryInfo(directory)
		files = dirInfo.GetFiles()
		for f in files:
			path = IO.Path.Combine(directory, f.Name)
			doc = Document(self, path)
			terms = doc.Process()
			for term in terms:
				if not Index.ContainsKey(term):
					Index.Add(term, List[of Document]())
				Index[term].Add(doc)
				Index[term].Sort() # TODO: inefficient
			
			Documents.Add(doc)
			
			print "Loaded ${doc.Title} with ${terms.Count} terms."
		
	public def CreateQueryProcessor():
		return QueryProcessor(self)

	public def RetrieveDocumentsForTerm(term as string):
		if Index.ContainsKey(term):
			return Index[term]
		return List[of string]()

class QueryProcessor:
	protected RetrievalSystem as RetrievalSystem
	private Stack = List[of List[of string]]()
	
	public def constructor(retrievalSystem as RetrievalSystem):
		RetrievalSystem = retrievalSystem

	public def ProcessQuery(query as Query) as List[of string]:
		query.Visit(self)
		result = Pop()
		return result

	public def VisitAndQuery(andQuery as AndQuery):
		andQuery.Left.Visit(self)
		andQuery.Right.Visit(self)
		left = Pop()
		right = Pop()
		result = List[of string]()
		for t in left:
			result.Add(t) if right.Contains(t)
		Push(result)
		
	public def VisitOrQuery(orQuery as OrQuery):
		andQuery.Left.Visit(self)
		andQuery.Right.Visit(self)
		left = Pop()
		right = Pop()
		left.AddRange(right)
		for t in right:
			left.Add(t) if not left.Contains(t)
		Push(left)
		
	public def VisitNotQuery(notQuery as NotQuery):
		andQuery.Left.Visit(self)
		andQuery.Right.Visit(self)
		left = Pop()
		right = Pop()
		result = List[of string]()
		for t in left:
			result.Add(t) if not right.Contains(t)
		Push(result)
		
	public def VisitTermQuery(termQuery as TermQuery):
		Push(RetrievalSystem.RetrieveDocumentsForTerm(termQuery.Term))
	
	protected def Push(terms as List[of string]):
		Stack.Add(terms)
		
	protected def Pop() as List[of string]:
		item = Stack[Stack.Count-1]
		Stack.RemoveAt(Stack.Count-1)
		return item

class Document:
	[Getter(RetrievalSystem)] _RetrievalSystem as RetrievalSystem
	"""The retrieval system to which this document belongs"""
	
	[Property(Title)] _Title as string
	"""This document's title"""
	
	[Property(Path)] _Path as string
	"""The path where this document is located"""
	
	public def constructor(retrievalSystem as RetrievalSystem, path as string):
		Path = path
		Title = IO.Path.GetFileName(path)
	
	public def Process() as List[of string]:
	"""Process the document to extract all terms in it"""
		lines = File.ReadAllLines(Path)
		terms = List[of string]()
		for line in lines:
			words = line.Split((" ", ",", ".", "!", "?", "-"), StringSplitOptions.RemoveEmptyEntries)
			for word in words:
				word = string.Intern(word.ToUpper())
				terms.Add(word) if not terms.Contains(word)
		terms.Sort()
		return terms
			
	public def ReadContent() as string:
		return File.ReadAllText(Path)

rs = RetrievalSystem("data/TIME/Docs")
processor = rs.CreateQueryProcessor()
query = AndQuery(TermQuery("VIET"), AndQuery(TermQuery("NAM"), TermQuery("COUP")))
print processor.ProcessQuery(query)
System.Console.ReadKey()