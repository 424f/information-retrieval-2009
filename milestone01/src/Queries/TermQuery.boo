namespace IR

import System

class TermQuery(Query):
	[Property(Term)] _term as string
	
	public def constructor(term as string):
		_term = term
		
	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitTermQuery(self)

	public def ToString() as string:
		return Term