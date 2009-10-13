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
	
	public def VisitProximityQuery(proxQuery as ProximityQuery):
		// First of all, retrieve all the documents in which all the terms occur
		words = proxQuery.Terms
		documents = RetrievalSystem.RetrieveDocumentsForWord(words[0])
		for i in range(1, words.Length):
			documents = SetUtils[of Document].Intersect(documents, RetrievalSystem.RetrieveDocumentsForWord(words[i]))
		
		// Filter documents
		prox = proxQuery.Proximity
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
			
			enumerators = array(SimpleEnumerator[of int], positions.Count)
			for k in range(positions.Count):
				enumerators[k] = SimpleEnumerator[of int](positions[k].GetEnumerator())
				enumerators[k].GetNext()
			
			j = 1
			found = false
			while not found and not enumerators[0].After:
				en = enumerators[j]
				while en.Current < enumerators[j-1].Current and not en.After:
					en.GetNext()
				if en.After or en.Current - enumerators[j-1].Current + 1 > prox:
					enumerators[0].GetNext()
					j = 1
				else:
					j += 1
					if j >= positions.Count:
						found = true
			// Filter
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

