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

	public def ToString() as string:
		return Term

class BinaryQuery(Query):
	[Property(Left)]
	_left as Query
	
	[Property(Right)]
	_right as Query

	public def constructor(left as Query, right as Query):
		_left = left
		_right = right
							
class AndQuery(BinaryQuery):
	
	public def constructor(left as Query, right as Query):
		super(left, right)
		
	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitAndQuery(self)

	public def ToString():
		return "(${Left} AND ${Right})"


class OrQuery(BinaryQuery):
	public def constructor(left as Query, right as Query):
		super(left, right)
		
	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitOrQuery(self)

	public def ToString():
		return "(${Left} OR ${Right})"

class NotQuery(BinaryQuery):
	public def constructor(left as Query, right as Query):
		super(left, right)

	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitNotQuery(self)

	public def ToString():
		return "(${Left} NOT ${Right})"

enum ParseDirection:
	ParseFromLeft
	ParseFromRight

class QueryBuilder():
	static public def Process(rs as RetrievalSystem, query as string, direction as ParseDirection):
		terms = List[of string]()
		items = List[of string](query.Split((Char.Parse(' '),), StringSplitOptions.RemoveEmptyEntries))
		
		# Remove all stopwords
		i = 0
		while i < items.Count:
			if rs.IsStopword(rs.GetTerm(items[i])):
				items.RemoveRange(i, (2 if i + 1 < items.Count else 1))
				continue
			i += 2
		
		if items.Count == 0:
			return TermQuery(null)
		
		# Reverse for parsing from right
		if direction == ParseDirection.ParseFromRight:
			items.Reverse()
		
		# Match a term
		left as Query = TermQuery(items[0])
		i = 1
		while i + 1 < items.Count:
			op = items[i]
			term = items[i+1]
			right = TermQuery(term)
			if op == "not":
				left = NotQuery(left, right)
			elif op == "and":
				left = AndQuery(left, right)
			elif op == "or":
				left = OrQuery(left, right)
			else:
				raise Exception("Unknown operator '${op}'")	
			i += 2
		
		if i < items.Count:
			raise Exception("Leftover expression ${items[items.Count-1]}")
			
		return left