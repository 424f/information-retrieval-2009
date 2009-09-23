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

	public def constructor(left as Query, right as Query):
		_left = left
		_right = right
	
	public def ToString():
		return "(l: " + _left + ", r: " + _right + ")"
						
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


class TreeBuilder():
	_current as BinaryQuery
	
	public def constructor():
		_current = BinaryQuery(null, null)

	public def AddTerm(q as TermQuery):
	
		if _current.Right == null:
			_current.Right = q
		if _current.Left == null:
			_current.Left = q
			_current = BinaryQuery(null, _current)
	
	public def GetTree():
		return _current.Right

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
		
		t = TreeBuilder()
		qterms = [ TermQuery(term) for term in terms ]
		for term in qterms[1:]:
			t.AddTerm(term)
			
		
		if type == QueryType.AND:
			return AndQuery(qterms[0], t.GetTree())
		if type == QueryType.OR:
			return OrQuery(qterms[0], t.GetTree())
		if type == QueryType.NOT:
			return NotQuery(qterms[0], t.GetTree())
		else:
			raise Exception("Malformed Query: " + query)


q = QueryBuilder.Process("HOT and LINE and PROPOSAL")
print q
