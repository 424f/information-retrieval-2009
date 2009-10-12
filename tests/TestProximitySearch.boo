namespace IR.Test

import System
import NUnit.Framework
import IR

[TestFixture]
class TestProximitySearch:
	protected RetrievalSystem as RetrievalSystem
	
	[TestFixtureSetUp] 
	public def Init():
		RetrievalSystem = RetrievalSystem()
		RetrievalSystem.CreateIndex("../../data/TIME/Docs/")
	
	[Test] public def TestQ1():
		RunTest("THERE HAS BEEN", ("doc122", "doc253", "doc343"))

	[Test] public def TestQ2():
		RunTest("ONE OF THE BEST", ("doc186", "doc294"))
		
	[Test] public def TestQ3():
		RunTest("POLITICAL PARTY", ("doc148", "doc159", "doc253", "doc377", "doc39", "doc6", "doc88"))

	[Test] public def TestQ4():
		RunTest("THE NEW REGIME", ("doc115", "doc121", "doc370", "doc370", "doc70", "doc70"))

	[Test] public def TestQ5():
		RunTest("DELEGATES MEETING", ("doc156", "doc47"))
		
	public def RunTest(query as string, expected as (string)):
		qp = RetrievalSystem.CreateQueryProcessor()
		q as Query = QueryBuilder.BuildProximityQuery(RetrievalSystem, query, 10)
		print q
		result = qp.ProcessQuery(q)
		
		// Make sure no unexpected documents were retrieved
		for doc in result:
			Assert.Contains(doc.Title, expected, "Result ${doc.Title} returned but not expected")
						
		// Make sure all expected documents were retrieved
		for docTitle in expected:
			Assert.AreNotEqual(null, result.Find({d as Document | d.Title == docTitle}), "Document ${docTitle} was not retrieved but was expected")		