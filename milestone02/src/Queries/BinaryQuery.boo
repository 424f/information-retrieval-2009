namespace IR

import System

abstract class BinaryQuery(Query):
	[Property(Left)] _left as Query	
	[Property(Right)] _right as Query

	public def constructor(left as Query, right as Query):
		_left = left
		_right = right
