namespace IR

import System

class PhraseQuery(ProximityQuery):	
	public def constructor(terms as (string)):
		super(terms, 2)
		_Terms = terms
		
	public def constructor(terms as string):
		self(terms.Split((" ", ), StringSplitOptions.RemoveEmptyEntries))