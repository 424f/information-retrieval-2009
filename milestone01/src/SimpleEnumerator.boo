namespace IR

import System
import System.Collections.Generic

public final class SimpleEnumerator[of T]:
"""This class helps you to keep track of an IEnumerator's state"""
	private Enumerable as IEnumerator[of T]
	
	public After as bool:
		get: return _After
	private _After as bool
	
	public Current as T:
		get: 
			return _Current
	private _Current as T
	
	public def constructor(e as IEnumerator[of T]):
		Enumerable = e
		_After = false

	public def constructor(e as IEnumerable[of T]):
		self(e.GetEnumerator())
		
	public def MoveNext() as bool:
		b = Enumerable.MoveNext()
		if b:
			_Current = Enumerable.Current
		else:
			_After = true
	
	public def GetNext() as T:
		MoveNext()
		return Current
