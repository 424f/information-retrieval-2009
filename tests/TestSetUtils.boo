namespace IR.Test

import System
import System.Collections.Generic
import NUnit.Framework
import IR

[TestFixture]
class TestSetUtils:
	[Test]
	public def TestUnion1():
		TestUnion((1, 2, 3), (2, 3, 4), (1, 2, 3, 4))
		
	[Test]
	public def TestUnion2():
		TestUnion((1, 2, 3), (4, 5), (1, 2, 3, 4, 5))

	[Test]
	public def TestUnion3():
		TestUnion((1, 2, 3), (1, 2, 3), (1, 2, 3))

	[Test]
	public def TestUnion4():
		TestUnion((of int:,), (1, 2, 3), (1, 2, 3))

	[Test]
	public def TestUnion5():
		TestUnion((1, 2, 3), (of int:,), (1, 2, 3))

	public def TestUnion(A as IEnumerable[of int], B as IEnumerable[of int], expected as IEnumerable[of int]):
		C = SetUtils[of Int32].Union(A, B)
		Assert.AreEqual(expected, C)
		
	// -----------
	
	[Test]
	public def TestIntersection1():
		TestIntersection((1, 2, 3), (2, 3, 4), (2, 3))
		
	[Test]
	public def TestIntersection2():
		TestIntersection((1, 2, 3), (4, 5), (of int:,))

	[Test]
	public def TestIntersection3():
		TestIntersection((1, 2, 3), (1, 2, 3), (1, 2, 3))	

	[Test]
	public def TestIntersection4():
		TestIntersection((of int:,), (1, 2, 3), (of int:,))

	[Test]
	public def TestIntersection5():
		TestIntersection((1, 2, 3), (of int:,), (of int:,))

	[Test]
	public def TestIntersection6():
		TestIntersection((3, 4, 5), (1, 2, 3), (3, ))
		
	public def TestIntersection(A as IEnumerable[of int], B as IEnumerable[of int], expected as IEnumerable[of int]):
		C = SetUtils[of Int32].Intersect(A, B)
		Assert.AreEqual(expected, C)		
		
	// -----------
	
	[Test]
	public def TestMinus1():
		TestMinus((1, 2, 3), (2, 3, 4), (1, ))
		
	[Test]
	public def TestMinus2():
		TestMinus((1, 2, 3), (4, 5), (1, 2, 3))

	[Test]
	public def TestMinus3():
		TestMinus((1, 2, 3), (1, 2, 3), (of int: ,))	

	[Test]
	public def TestMinus4():
		TestMinus((of int:,), (1, 2, 3), (of int:,))

	[Test]
	public def TestMinus5():
		TestMinus((1, 2, 3), (of int:,), (1, 2, 3))

	[Test]
	public def TestMinus6():
		TestMinus((3, 4, 5), (1, 2, 3), (4, 5))
		
	public def TestMinus(A as IEnumerable[of int], B as IEnumerable[of int], expected as IEnumerable[of int]):
		C = SetUtils[of Int32].Minus(A, B)
		Assert.AreEqual(expected, C)				