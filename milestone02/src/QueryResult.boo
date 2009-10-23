namespace IR

import System

class QueryResult(IComparable):
	[Getter(Document)] _Document as Document
	[Getter(Score)] _Score as double
	
	public def constructor(document as Document, score as double):
		_Document = document
		_Score = score

	public def CompareTo(other as object) as int:
		otherResult = other as QueryResult
		return -self.Score.CompareTo(otherResult.Score)