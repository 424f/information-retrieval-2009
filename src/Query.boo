namespace IR
import System
import System.Collections.Generic

abstract class Query():
		
	public virtual def Visit(visitor as IQueryVisitor):
		pass

interface IQueryVisitor:
	def VisitAndQuery(andQuery as AndQuery)
	def VisitOrQuery(orQuery as OrQuery)
	def VisitNotQuery(notQuery as NotQuery)
	def VisitTermQuery(termQuery as TermQuery)

class TermQuery(Query):
	[Property(Term)]
	_term as string
	
	public def constructor(term as string):
		_term = term
		
	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitTermQuery(self)

class BinaryQuery(Query):
	[Property(Left)]
	_left as Query
	
	[Property(Right)]
	_right as Query

	public def constructor():
		pass

	public def constructor(left as Query, right as Query):
		_left = left
		_right = right
						
class AndQuery(BinaryQuery):
	public def constructor(left as Query, right as Query):
		super(left, right)

	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitAndQuery(self)


class OrQuery(BinaryQuery):
	public def constructor(left as Query, right as Query):
		super(left, right)
		
	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitOrQuery(self)


class NotQuery(BinaryQuery):

	public def constructor(left as Query, right as Query):
		super(left, right)

	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitNotQuery(self)


class QueryBuilder():
	enum QueryType:
		AND = 0
		OR = 1
		NOT = 2
		
	static public def Process(query as string):
		type as QueryType
		terms = List[of string]()

		for item in query.Split(Char.Parse(' ')):
			if item == "and":
				type = QueryType.AND
			elif item == "or":
				type = QueryType.OR
			elif item == "not":
				type = QueryType.NOT
			else:
				terms.Add(item)
		
		qterms = [ TermQuery(term) for term in terms ]
		
		right = null
		left = null
		node = BinaryQuery()
		i = 0
		for term in qterms[1:]:
			if i % 2 == 0:
				node.Left = term
			else:
				node.Left = term
			
			i += 1
		
		/*if len(terms[1:]) == 1:
			right = TermQuery(terms[-1])
		elif len(terms[1:]) > 1:*/
			
		/*	
		if type == QueryType.AND:
			return AndQuery(terms[0], right)
		if type == QueryType.OR:
			return OrQuery(terms[0], right)
		if type == QueryType.NOT:
			return NotQuery(left, right)
		else:
			raise Exception("Malformed Query: " + query)*/


//q = QueryBuilder.Process("HOT and LINE and PROPOSAL")

