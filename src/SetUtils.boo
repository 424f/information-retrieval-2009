namespace IR

import System
import System.Collections.Generic

static class SetUtils[of T(IComparable)]:
"""Provides methods that operate on sets that are represented by _sorted_ IEnumerables"""	
	static public def Intersect(left as IEnumerable[of T], right as IEnumerable[of T]) as List[of T]:
		result = List[of T]()
		ls = SimpleEnumerator[of T](left.GetEnumerator())
		ls.MoveNext()
		rs = SimpleEnumerator[of T](right.GetEnumerator())
		rs.MoveNext()
		while not ls.After and not rs.After:
			if ls.Current == rs.Current:
				result.Add(ls.Current)
				ls.MoveNext()
				rs.MoveNext()
			elif ls.Current.CompareTo(rs.Current) < 0:
				ls.MoveNext()
			else:
				rs.MoveNext()
		return result
		
	static public def Union(left as IEnumerable[of T], right as IEnumerable[of T]) as List[of T]:
		result = List[of T]()
		ls = SimpleEnumerator[of T](left.GetEnumerator())
		l as T = ls.GetNext()
		
		rs = SimpleEnumerator[of T](right.GetEnumerator())
		r as T = rs.GetNext()
		
		while not ls.After or not rs.After:
			while not ls.After and (rs.After or l.CompareTo(r) < 0):
				result.Add(l)
				l = ls.GetNext()
			
			while not ls.After and not rs.After and l == r:
				result.Add(l)
				l = ls.GetNext()
				r = rs.GetNext()
				
			while not rs.After and (ls.After or r.CompareTo(l) < 0):
				result.Add(r)
				r = rs.GetNext()
		
		return result
		
	static public def Minus(left as IEnumerable[of T], right as IEnumerable[of T]) as List[of T]:
		result = List[of T]()
		ls = SimpleEnumerator[of T](left.GetEnumerator())
		ls.MoveNext()
		rs = SimpleEnumerator[of T](right.GetEnumerator())
		rs.MoveNext()
		while not ls.After:
			if rs.After or ls.Current.CompareTo(rs.Current) < 0:
				result.Add(ls.Current)
				ls.MoveNext()
			elif not ls.After and not rs.After and ls.Current == rs.Current:
				ls.MoveNext()
				rs.MoveNext()
			else:
				rs.MoveNext()
		return result
				
protected final class SimpleEnumerator[of T]:
"""This class helps you to keep track of a IEnumerator"""
	protected Enumerable as IEnumerator[of T]
	
	public After as bool:
		get: return _After
	protected _After as bool
	
	public Current as T:
		get: 
			return _Current
	protected _Current as T
	
	public def constructor(e as IEnumerator[of T]):
		Enumerable = e
		_After = false
		
	public def MoveNext() as bool:
		b = Enumerable.MoveNext()
		if b:
			_Current = Enumerable.Current
		else:
			_After = true
	
	public def GetNext() as T:
		MoveNext()
		return Current
		