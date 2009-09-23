namespace IR
import System
import System.Collections.Generic

abstract class Query():
	[Property(Terms)]
	_terms as List[of string]

	public def constructor(terms as List[of string]):
		_terms = terms
		
	public virtual def Visit[of T](visitor as IQueryVisitor):
		pass

interface IQueryVisitor:
	def VisitAndQuery(andQuery as Query)
	def VisitOrQuery(orQuery as Query)
	def VisitNotQuery(notQuery as Query)


		
class AndQuery(Query):

	public def constructor(terms as List[of string]):
		super(terms)

	public override def Visit(visitor as IQueryVisitor):
		return visitor.VisitAndQuery(self)


class OrQuery(Query):

	public def constructor(terms as List[of string]):
		super(terms)
		
	public override def Visit(visitor as IQueryVisitor):
		return visitor.VisitOrQuery(self)


class NotQuery(Query):

	public def constructor(terms as List[of string]):
		super(terms)

	public override def Visit(visitor as IQueryVisitor):
		return visitor.VisitNotQuery(self)


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
		
		if type == QueryType.AND:
			return AndQuery(terms)
		if type == QueryType.OR:
			return OrQuery(terms)
		if type == QueryType.NOT:
			return NotQuery(terms)
		else:
			raise Exception("Malformed Query: " + query)


q = QueryBuilder.Process("HOT and LINE and PROPOSAL")
for term in  q.Terms:
	print term
