namespace IR

import System
import System.IO
import System.Collections.Generic

struct Term(IComparable[of Term]):
	public ID as int
	
	public def CompareTo(other as Term) as int:
		return self.ID.CompareTo(other.ID)
		
	public override def Equals(other as object) as bool:
		return false if not other isa Term
		return self.ID == cast(Term, other).ID
	
	public override def GetHashCode() as int:
		return ID.GetHashCode()
	
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
	protected Words = Dictionary[of Term, string]()
	protected Stopwords = array(Term, 0)
	public DocumentProcessor as IDocumentProcessor
	[Getter(NumTerms)] _NumTerms = 0
	[Getter(NumDocuments)] _NumDocuments = 0
	
	public NullTerm:
		get: return _NullTerm
	private _NullTerm as Term

	public event DocumentLoaded as EventHandler[of DocumentLoadedArgs]
	
	public def constructor():
		DocumentProcessor = DocumentProcessor(self)
		
		// Create a null term that never occurs in any document
		_NullTerm = Term()
		_NullTerm.ID = NumTerms
		_NumTerms += 1		
		
	public def LoadStopwords(path as string):
		stopwords = File.ReadAllLines(path)
		Stopwords = array(Term, stopwords.Length)
		for i in range(stopwords.Length):
			Stopwords[i] = GetTerm(stopwords[i].ToUpper().Trim())
		Array.Sort[of Term](Stopwords)
		
	public def IsStopword(term as Term):
		word = Words[term]
		i = Array.BinarySearch[of Term](Stopwords, term)
		return i >= 0 and i < Stopwords.Length
		
	public def CreateIndex(directory as string):
		# Read all files
		dirInfo = DirectoryInfo(directory)
		files = dirInfo.GetFiles()
		_NumDocuments = files.Length
		for f in files:
			path = IO.Path.Combine(directory, f.Name)
			doc = Document(self, path)
			terms = doc.Process(DocumentProcessor)
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
		term = GetTerm(word)
		return RetrieveDocumentsForTerm(term)
		
	public def RetrieveDocumentsForTerm(term as Term) as List[of Document]:
		if Index.ContainsKey(term):
			return Index[term]
		return List[of Document]()
	
	public def RetrieveDocumentsForTerm(termId as int) as List[of Document]:
		term = Term()
		term.ID = termId
		return RetrieveDocumentsForTerm(term)

	public def GetTerm(word as string) as Term:
		return NullTerm if word == null
		word = word.Trim().ToUpper()
		if not Terms.ContainsKey(word):
			term = Term()
			term.ID = NumTerms
			_NumTerms += 1
			Terms.Add(word, term)
			Words.Add(term, word)
		return Terms[word]

class QueryProcessor(IQueryVisitor):
	protected RetrievalSystem as RetrievalSystem
	private Stack = List[of List[of Document]]()
	
	public def constructor(retrievalSystem as RetrievalSystem):
		RetrievalSystem = retrievalSystem

	public def Accept(query as Query) as List[of Document]:
		query.Visit(self)
		return Pop()

	public def ProcessQuery(query as Query) as List[of Document]:
		query.Visit(self)
		result = Pop()
		return result

	public def VisitAndQuery(andQuery as AndQuery) as void:
		left = Accept(andQuery.Left)
		right = Accept(andQuery.Right)
		Push(SetUtils[of Document].Intersect(left, right))
		
	public def VisitOrQuery(orQuery as OrQuery) as void:
		left = Accept(orQuery.Left)
		right = Accept(orQuery.Right)
		Push(SetUtils[of Document].Union(left, right))
		
	public def VisitNotQuery(notQuery as NotQuery) as void:
		left = Accept(notQuery.Left)
		right = Accept(notQuery.Right)
		Push(SetUtils[of Document].Minus(left, right))
		
	public def VisitTermQuery(termQuery as TermQuery) as void:
		Push(RetrievalSystem.RetrieveDocumentsForWord(termQuery.Term))
	
	protected def Push(terms as List[of Document]) as void:
		Stack.Add(terms)
		
	protected def Pop() as List[of Document]:
		item = Stack[Stack.Count-1]
		Stack.RemoveAt(Stack.Count-1)
		return item

class Document(IComparable[of Document], IComparable):
	[Getter(RetrievalSystem)] _RetrievalSystem as RetrievalSystem
	"""The retrieval system to which this document belongs"""
	
	[Getter(Id)] _Id as int
	"""Unique identifier for this instance"""
	
	[Property(Title)] _Title as string
	"""This document's title"""
	
	[Property(Path)] _Path as string
	"""The path where this document is located"""
	
	static protected NumDocuments = 0
	
	public def constructor(retrievalSystem as RetrievalSystem, path as string):
		Path = path
		Title = IO.Path.GetFileName(path)
		_RetrievalSystem = retrievalSystem
		
		NumDocuments += 1
		_Id = NumDocuments
	
	public def Process(processor as IDocumentProcessor) as List[of Term]:
	"""Process the document to extract all terms in it"""
		return processor.Process(Path)
			
	public def ReadContent() as string:
		return File.ReadAllText(Path)

	public def CompareTo(other as Document) as int:
		return self.Title.CompareTo(other.Title)

	public def CompareTo(other as object) as int:
		return CompareTo(other as Document)

	public static def op_LessThan(d1 as Document, d2 as Document):
		return d1.CompareTo(d2) < 0
 