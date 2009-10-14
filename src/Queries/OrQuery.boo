namespace IR

import System

class OrQuery(BinaryQuery):
	public def constructor(left as Query, right as Query):
		super(left, right)
		
	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitOrQuery(self)

	public def ToString():
		return "(${Left} OR ${Right})"
