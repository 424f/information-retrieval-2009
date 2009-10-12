namespace IR

import System
import System.Collections.Generic

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

	public def VisitAndQuery(andQuery as AndQuery):
		left = Accept(andQuery.Left)
		right = Accept(andQuery.Right)
		Push(SetUtils[of Document].Intersect(left, right))
		
	public def VisitOrQuery(orQuery as OrQuery):
		left = Accept(orQuery.Left)
		right = Accept(orQuery.Right)
		Push(SetUtils[of Document].Union(left, right))
		
	public def VisitNotQuery(notQuery as NotQuery):
		left = Accept(notQuery.Left)
		right = Accept(notQuery.Right)
		Push(SetUtils[of Document].Minus(left, right))
		
	public def VisitTermQuery(termQuery as TermQuery):
		Push(RetrievalSystem.RetrieveDocumentsForWord(termQuery.Term))
	
	public def VisitPhraseQuery(phraseQuery as PhraseQuery):
		// First of all, retrieve all the documents in which all the terms occur
		words = phraseQuery.Terms
		documents = RetrievalSystem.RetrieveDocumentsForWord(words[0])
		for i in range(1, words.Length):
			documents = SetUtils[of Document].Intersect(documents, RetrievalSystem.RetrieveDocumentsForWord(words[i]))
		
		// Now for every document, make sure it actually contains the _phrase_
		i = 0
		while i < documents.Count:
			// Retrieve positions
			doc = documents[i]
			positions = List[of List[of int]](words.Length)
			j = 0
			for word in words:
				term = RetrievalSystem.GetTerm(word)
				positions.Add(RetrievalSystem.RetrievePositionsForTermInDocument(term, doc))
				j += 1
			
			// Filter
			found = false
			for pos in positions[0]:
				invalid = false
				for j in range(1, words.Length):
					if positions[j].IndexOf(pos + j) == -1:
						invalid = true
						break
				if not invalid:
					found = true
			
			if not found:
				documents.RemoveAt(i)
			else:
				i += 1
			
		// Now we should only have valid results
		Push(documents)
	
	protected def PositionalIntersect(pos1 as List[of int], pos2 as List[of int], k as int) as List[of int]:
		result = List[of int]()
		p1 = SimpleEnumerator[of int](pos1)
		p1.MoveNext()
		p2 = SimpleEnumerator[of int](pos2)
		p2.MoveNext()
		
		l = List[of int]()
		while not p1.After:
			while not p2.After:	
				if Math.Abs(p2.Current - p1.Current) <= k:
					l.Add(p2.Current)
				elif p2.Current > p1.Current:
					break
				p2.MoveNext()
			while l.Count != 0 and Math.Abs(l[0] - p1.Current) > k:
				l.RemoveAt(0)
			for ps in l:
				result.Add(ps)
			p1.MoveNext()	
		return l	
	
	public def VisitProximityQuery(proxQuery as ProximityQuery):
		// First of all, retrieve all the documents in which all the terms occur
		words = proxQuery.Terms
		documents = RetrievalSystem.RetrieveDocumentsForWord(words[0])
		for i in range(1, words.Length):
			documents = SetUtils[of Document].Intersect(documents, RetrievalSystem.RetrieveDocumentsForWord(words[i]))
		
		// Now for every document, make sure it actually corresponds to the query
		prox = proxQuery.Proximity
		i = 0
		while i < documents.Count:
			// Retrieve positions
			doc = documents[i]
			if doc.Title == "doc148":
				print "YEAAAAAH"
			positions = List[of List[of int]](words.Length)
			j = 0
			for word in words:
				term = RetrievalSystem.GetTerm(word)
				positions.Add(RetrievalSystem.RetrievePositionsForTermInDocument(term, doc))
				j += 1
			
			// Filter
			found = true
			current = positions[0]
			for j in range(1, words.Length):
				current = PositionalIntersect(current, positions[j], prox)
				if current.Count == 0:
					found = false
					break			
			if not found:
				documents.RemoveAt(i)
			else:
				i += 1
			
		// Now we should only have valid results
		Push(documents)		
	
	protected def Push(docs as List[of Document]):
		Stack.Add(docs)
		
	protected def Pop() as List[of Document]:
		item = Stack[Stack.Count-1]
		Stack.RemoveAt(Stack.Count-1)
		return item

