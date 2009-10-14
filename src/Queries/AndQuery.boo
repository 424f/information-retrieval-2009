namespace IR

import System

class AndQuery(BinaryQuery):
	public def constructor(left as Query, right as Query):
		super(left, right)
		
	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitAndQuery(self)

	public def ToString():
		return "(${Left} AND ${Right})"