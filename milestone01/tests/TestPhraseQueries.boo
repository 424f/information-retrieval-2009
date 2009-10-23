namespace IR.Test

import System
import NUnit.Framework
import IR

[TestFixture]
class TestPhraseQueries:
	protected RetrievalSystem as RetrievalSystem
	
	[TestFixtureSetUp] 
	public def Init():
		RetrievalSystem = RetrievalSystem()
		RetrievalSystem.CreateIndex("../../data/TIME/Docs/")
		//Phrase Search [ = Proximity search with window size = 2]
	
	[Test] public def TestQ1():
		RunTest("THERE HAS BEEN", ("doc122", "doc253", "doc343"))

	[Test] public def TestQ2():
		RunTest("ONE OF THE BEST", ("doc186", ))
		
	[Test] public def TestQ3():
		RunTest("POLITICAL PARTY", ("doc159", "doc6"))

	[Test] public def TestQ4():
		RunTest("THE NEW REGIME", ("doc121", "doc370", "doc370", "doc70", "doc70"))

	[Test] public def TestQ5():
		RunTest("DELEGATES MEETING", (of string: ,))
		
	public def RunTest(query as string, expected as (string)):
		qp = RetrievalSystem.CreateQueryProcessor()
		q as Query = QueryBuilder.BuildPhraseQuery(RetrievalSystem, query)
		print q
		result = qp.ProcessQuery(q)
		
		// Make sure no unexpected documents were retrieved
		for doc in result:
			Assert.Contains(doc.Title, expected, "Result ${doc.Title} returned but not expected")
						
		// Make sure all expected documents were retrieved
		for docTitle in expected:
			Assert.AreNotEqual(null, result.Find({d as Document | d.Title == docTitle}), "Document ${docTitle} was not retrieved but was expected")		