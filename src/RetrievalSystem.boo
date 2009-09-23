namespace IR

import System
import System.IO
import System.Collections.Generic

struct Term(IComparable[of Term]):
	public ID as int
	
	public def CompareTo(other as Term) as int:
		return self.ID.CompareTo(other.ID)
		
class DocumentLoadedArgs(EventArgs):
	[Getter(Document)] _Document as Document
	[Getter(NumTerms)] _NumTerms as int
	
	public def constructor(document as Document, numTerms as int):
		_Document = document
		_NumTerms = numTerms
		
class RetrievalSystem:
	protected Documents = List[of Document]()
	protected Index = Dictionary[of Term, List[of Document]]()
	protected Terms = Dictionary[of string, Term]()
	protected NumTerms = 0
	[Getter(NumDocuments)] _NumDocuments = 0

	public event DocumentLoaded as EventHandler[of DocumentLoadedArgs]

	public def constructor():
		pass
		
	public def CreateIndex(directory as string):
		# Read all files
		dirInfo = DirectoryInfo(directory)
		files = dirInfo.GetFiles()
		_NumDocuments = files.Length
		for f in files:
			path = IO.Path.Combine(directory, f.Name)
			doc = Document(self, path)
			terms = doc.Process()
			for term in terms:
				if not Index.ContainsKey(term):
					Index.Add(term, List[of Document]())
				Index[term].Add(doc)
			
			Documents.Add(doc)			
			DocumentLoaded(self, DocumentLoadedArgs(doc, terms.Count))
		# Sort indices
		for term in Index.Keys:
			Index[term].Sort()

	public def CreateQueryProcessor() as QueryProcessor:
		return QueryProcessor(self)

	public def RetrieveDocumentsForWord(word as string) as List[of Document]:
		word = word.Trim().ToUpper()
		term = GetTerm(word)
		if Index.ContainsKey(term):
			return Index[term]
		return List[of Document]()

	public def GetTerm(word as string) as Term:
		if not Terms.ContainsKey(word):
			term = Term()
			term.ID = NumTerms
			NumTerms += 1
			Terms.Add(word, term)
		return Terms[word]

class QueryProcessor(IQueryVisitor):
	protected RetrievalSystem as RetrievalSystem
	private Stack = List[of List[of Document]]()
	
	public def constructor(retrievalSystem as RetrievalSystem):
		RetrievalSystem = retrievalSystem

	public def ProcessQuery(query as Query) as List[of Document]:
		query.Visit(self)
		result = Pop()
		return result

	public def VisitAndQuery(andQuery as AndQuery) as void:
		andQuery.Left.Visit(self)
		left = Pop()
		andQuery.Right.Visit(self)
		right = Pop()
		result = List[of Document]()
		for t in left:
			result.Add(t) if right.Contains(t)
		Push(result)
		
	public def VisitOrQuery(orQuery as OrQuery) as void:
		orQuery.Left.Visit(self)
		orQuery.Right.Visit(self)
		left = Pop()
		right = Pop()
		left.AddRange(right)
		for t in right:
			left.Add(t) if not left.Contains(t)
		Push(left)
		
	public def VisitNotQuery(notQuery as NotQuery) as void:
		notQuery.Left.Visit(self)
		left = Pop()
		notQuery.Right.Visit(self)
		right = Pop()
		result = List[of Document]()
		for t in left:
			result.Add(t) if not right.Contains(t)
		Push(result)
		
	public def VisitTermQuery(termQuery as TermQuery) as void:
		Push(RetrievalSystem.RetrieveDocumentsForWord(termQuery.Term))
	
	protected def Push(terms as List[of Document]) as void:
		Stack.Add(terms)
		
	protected def Pop() as List[of Document]:
		item = Stack[Stack.Count-1]
		Stack.RemoveAt(Stack.Count-1)
		return item

class Document(IComparable[of Document]):
	[Getter(RetrievalSystem)] _RetrievalSystem as RetrievalSystem
	"""The retrieval system to which this document belongs"""
	
	[Property(Title)] _Title as string
	"""This document's title"""
	
	[Property(Path)] _Path as string
	"""The path where this document is located"""
	
	static SplitRule = regex("[^a-zA-Z0-9]")
	
	public def constructor(retrievalSystem as RetrievalSystem, path as string):
		Path = path
		Title = IO.Path.GetFileName(path)
		_RetrievalSystem = retrievalSystem
	
	public def Process() as List[of Term]:
	"""Process the document to extract all terms in it"""
		lines = File.ReadAllLines(Path)
		terms = List[of Term]()
		for line in lines:
			words = SplitRule.Split(line)
			for word in words:
				word = word.ToUpper().Trim()
				continue if word.Length == 0
				term = RetrievalSystem.GetTerm(word)
				i = terms.BinarySearch(term)
				if i < 0:
					terms.Insert(~i, term)						
		terms.Sort()
		return terms
			
	public def ReadContent() as string:
		return File.ReadAllText(Path)

	public def CompareTo(other as Document) as int:
		return self.Title.CompareTo(other.Title)
