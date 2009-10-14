namespace IR
import System

abstract class Query():	
	public virtual def Visit(visitor as IQueryVisitor):
		pass