namespace IR

import System

class ProximityQuery(Query):
	[Property(Terms)] _Terms as (string)
	[Property(Proximity)] _Proximity as int

	public def constructor(terms as string, proximity as int):
		self(terms.Split((" ", ), StringSplitOptions.RemoveEmptyEntries), proximity)
	
	public def constructor(terms as (string), proximity as int):
		_Terms = terms
		_Proximity = proximity
		
	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitProximityQuery(self)

	public def ToString() as string:
		return _Terms.ToString()
