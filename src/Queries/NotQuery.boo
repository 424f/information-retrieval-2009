namespace IR

import System

class NotQuery(BinaryQuery):
	public def constructor(left as Query, right as Query):
		super(left, right)

	public override def Visit(visitor as IQueryVisitor):
		visitor.VisitNotQuery(self)

	public def ToString():
		return "(${Left} NOT ${Right})"