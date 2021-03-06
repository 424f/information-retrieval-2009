namespace IR.Test

import System
import NUnit.Framework
import IR

[TestFixture]
class TestStopwordEleminator:
	protected RetrievalSystem as RetrievalSystem
	
	[TestFixtureSetUp] 
	public def Init():
		RetrievalSystem = RetrievalSystem()
		RetrievalSystem.LoadStopwords("../../data/stopwords.txt")
		RetrievalSystem.CreateIndex("../../data/TIME/Docs/")
		
	[Test]
	public def TestQ0():
		RunTest("is and are and the and a and then and before and after and but and an and also and since and among and already", (of string:,))		

	[Test]
	public def TestQ23():
		RunTest("COUNTRY or NEW or JOIN or UNITED or NATIONS", ("doc100", "doc104", "doc107", "doc108", "doc11", "doc115", "doc116", "doc121", "doc122", "doc125", "doc128", "doc132", "doc135", "doc138", "doc14", "doc140", "doc142", "doc144", "doc145", "doc148", "doc151", "doc156", "doc158", "doc159", "doc160", "doc162", "doc168", "doc175", "doc176", "doc177", "doc182", "doc184", "doc185", "doc188", "doc189", "doc193", "doc194", "doc195", "doc196", "doc198", "doc201", "doc202", "doc209", "doc212", "doc214", "doc215", "doc221", "doc226", "doc227", "doc228", "doc230", "doc231", "doc233", "doc234", "doc235", "doc237", "doc242", "doc247", "doc248", "doc25", "doc250", "doc251", "doc253", "doc254", "doc255", "doc257", "doc258", "doc26", "doc260", "doc261", "doc262", "doc264", "doc267", "doc269", "doc27", "doc270", "doc271", "doc272", "doc274", "doc275", "doc278", "doc280", "doc283", "doc285", "doc290", "doc292", "doc294", "doc295", "doc298", "doc300", "doc304", "doc305", "doc307", "doc308", "doc309", "doc314", "doc315", "doc316", "doc319", "doc32", "doc321", "doc323", "doc326", "doc327", "doc328", "doc329", "doc331", "doc334", "doc337", "doc339", "doc340", "doc341", "doc342", "doc343", "doc345", "doc349", "doc35", "doc350", "doc352", "doc355", "doc356", "doc358", "doc359", "doc36", "doc361", "doc363", "doc367", "doc369", "doc370", "doc371", "doc373", "doc374", "doc377", "doc378", "doc381", "doc382", "doc383", "doc384", "doc386", "doc388", "doc389", "doc39", "doc390", "doc391", "doc393", "doc396", "doc397", "doc4", "doc40", "doc400", "doc401", "doc404", "doc406", "doc407", "doc408", "doc41", "doc410", "doc413", "doc415", "doc416", "doc418", "doc425", "doc43", "doc45", "doc46", "doc47", "doc48", "doc49", "doc50", "doc53", "doc54", "doc55", "doc56", "doc59", "doc6", "doc60", "doc66", "doc7", "doc70", "doc71", "doc73", "doc76", "doc78", "doc79", "doc80", "doc82", "doc86", "doc88", "doc89", "doc94", "doc99"))

	public def RunTest(query as string, expected as (string)):
		qp = RetrievalSystem.CreateQueryProcessor()
		q as Query = QueryBuilder.BuildQuery(RetrievalSystem, query, ParseDirection.ParseFromLeft)
		print q
		result = qp.ProcessQuery(q)
		
		// Make sure no unexpected documents were retrieved
		for doc in result:
			Assert.Contains(doc.Title, expected, "Result ${doc.Title} returned but not expected")
						
		// Make sure all expected documents were retrieved
		for docTitle in expected:
			Assert.AreNotEqual(null, result.Find({d as Document | d.Title == docTitle}), "Document ${docTitle} was not retrieved but was expected")		