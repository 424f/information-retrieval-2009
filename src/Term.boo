namespace IR

import System
import System.IO
import System.Collections.Generic

struct Term(IComparable[of Term]):
	public ID as int
	
	public def CompareTo(other as Term) as int:
		return self.ID.CompareTo(other.ID)
		
	public override def Equals(other as object) as bool:
		return false if not other isa Term
		return self.ID == cast(Term, other).ID
	
	public override def GetHashCode() as int:
		return ID.GetHashCode()