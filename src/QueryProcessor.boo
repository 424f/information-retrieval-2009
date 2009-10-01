namespace IR

import System
import System.Collections.Generic

class QueryStopwordEleminator(IQueryVisitor):
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
