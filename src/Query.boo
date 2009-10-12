namespace IR
import System

abstract class Query():	
	public virtual def Visit(visitor as IQueryVisitor):
		pass

interface IQueryVisitor:
	def VisitAndQuery(andQuery as AndQuery)
	def VisitOrQuery(orQuery as OrQuery)
	def VisitNotQuery(notQuery as NotQuery)
	def VisitTermQuery(termQuery as TermQuery)
	def VisitPhraseQuery(phraseQuery as PhraseQuery)
	def VisitProximityQuery(proximityQuery as ProximityQuery)

class TermQuery(Query):
	[Property(Term)] _term as string
	
	public def constructor(term as string):
		_term = term
		
	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitTermQuery(self)

	public def ToString() as string:
		return Term

class PhraseQuery(Query):
	[Property(Terms)] _Terms as (string)
	
	public def constructor(terms as (string)):
		_Terms = terms
		
	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitPhraseQuery(self)

	public def ToString() as string:
		return _Terms.ToString()

class ProximityQuery(Query):
	[Property(Terms)] _Terms as (string)
	[Property(Proximity)] _Proximity as int
	
	public def constructor(terms as (string), proximity as int):
		_Terms = terms
		_Proximity = proximity
		
	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitProximityQuery(self)

	public def ToString() as string:
		return _Terms.ToString()

class BinaryQuery(Query):
	[Property(Left)] _left as Query	
	[Property(Right)] _right as Query

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