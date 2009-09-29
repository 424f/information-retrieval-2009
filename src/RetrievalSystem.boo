﻿namespace IR

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
	[Getter(NumTerms)] _NumTerms = 0
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
		if not Terms.ContainsKey(word):
			term = Term()
			term.ID = NumTerms
			_NumTerms += 1
			Terms.Add(word, term)
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
	static protected SplitRule = regex("[^a-zA-Z0-9]")
	
	public def constructor(retrievalSystem as RetrievalSystem, path as string):
		Path = path
		Title = IO.Path.GetFileName(path)
		_RetrievalSystem = retrievalSystem
		
		NumDocuments += 1
		_Id = NumDocuments
	
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
		return terms
			
	public def ReadContent() as string:
		return File.ReadAllText(Path)

	public def CompareTo(other as Document) as int:
		return self.Title.CompareTo(other.Title)

	public def CompareTo(other as object) as int:
		return CompareTo(other as Document)

	public static def op_LessThan(d1 as Document, d2 as Document):
		return d1.CompareTo(d2) < 0
 