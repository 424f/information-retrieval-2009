namespace IR
import System
import NUnit.Framework


[TestFixture()]
class TestOutput():
	protected RetrievalSystem as RetrievalSystem
	
	[TestFixtureSetUp] 
	public def Init():
		RetrievalSystem = RetrievalSystem()
		RetrievalSystem.CreateIndex("../../data/TIME/Docs/")

	[Test]
	public def TestQ23():
		RunTest("COUNTRY or NEW or JOIN or UNITED or NATIONS", ("doc10", "doc100", "doc104", "doc107", "doc108", "doc109", "doc11", "doc110", "doc112", "doc113", "doc114", "doc115", "doc116", "doc118", "doc120", "doc121", "doc122", "doc125", "doc126", "doc127", "doc128", "doc13", "doc131", "doc132", "doc135", "doc136", "doc138", "doc139", "doc14", "doc140", "doc142", "doc144", "doc145", "doc146", "doc147", "doc148", "doc15", "doc151", "doc152", "doc154", "doc155", "doc156", "doc157", "doc158", "doc159", "doc160", "doc162", "doc164", "doc167", "doc168", "doc170", "doc171", "doc174", "doc175", "doc176", "doc177", "doc18", "doc182", "doc184", "doc185", "doc188", "doc189", "doc190", "doc192", "doc193", "doc194", "doc195", "doc196", "doc198", "doc20", "doc201", "doc202", "doc205", "doc207", "doc208", "doc209", "doc21", "doc210", "doc211", "doc212", "doc214", "doc215", "doc216", "doc22", "doc221", "doc222", "doc223", "doc224", "doc225", "doc226", "doc227", "doc228", "doc229", "doc230", "doc231", "doc233", "doc234", "doc235", "doc237", "doc238", "doc24", "doc240", "doc241", "doc242", "doc243", "doc245", "doc247", "doc248", "doc25", "doc250", "doc251", "doc252", "doc253", "doc254", "doc255", "doc256", "doc257", "doc258", "doc26", "doc260", "doc261", "doc262", "doc264", "doc265", "doc266", "doc267", "doc269", "doc27", "doc270", "doc271", "doc272", "doc274", "doc275", "doc276", "doc277", "doc278", "doc280", "doc281", "doc283", "doc284", "doc285", "doc286", "doc290", "doc291", "doc292", "doc293", "doc294", "doc295", "doc297", "doc298", "doc300", "doc301", "doc302", "doc303", "doc304", "doc305", "doc306", "doc307", "doc308", "doc309", "doc313", "doc314", "doc315", "doc316", "doc319", "doc32", "doc320", "doc321", "doc323", "doc326", "doc327", "doc328", "doc329", "doc331", "doc333", "doc334", "doc337", "doc339", "doc340", "doc341", "doc342", "doc343", "doc345", "doc346", "doc347", "doc348", "doc349", "doc35", "doc350", "doc351", "doc352", "doc355", "doc356", "doc357", "doc358", "doc359", "doc36", "doc360", "doc361", "doc363", "doc366", "doc367", "doc369", "doc370", "doc371", "doc373", "doc374", "doc377", "doc378", "doc379", "doc381", "doc382", "doc383", "doc384", "doc385", "doc386", "doc387", "doc388", "doc389", "doc39", "doc390", "doc391", "doc392", "doc393", "doc394", "doc396", "doc397", "doc398", "doc399", "doc4", "doc40", "doc400", "doc401", "doc403", "doc404", "doc406", "doc407", "doc408", "doc409", "doc41", "doc410", "doc411", "doc413", "doc414", "doc415", "doc416", "doc417", "doc418", "doc419", "doc420", "doc421", "doc424", "doc425", "doc43", "doc45", "doc46", "doc47", "doc48", "doc49", "doc50", "doc52", "doc53", "doc54", "doc55", "doc56", "doc57", "doc58", "doc59", "doc6", "doc60", "doc61", "doc63", "doc64", "doc65", "doc66", "doc69", "doc7", "doc70", "doc71", "doc72", "doc73", "doc74", "doc75", "doc76", "doc78", "doc79", "doc80", "doc81", "doc82", "doc84", "doc86", "doc87", "doc88", "doc89", "doc90", "doc92", "doc94", "doc96", "doc99", ))

	[Test]
	public def TestQ48():
		RunTest("HOT and LINE and PROPOSAL", ("doc306", ))


	[Test]
	public def TestQ5():
		RunTest(" VIET and NAM and COUP", ("doc304", "doc326", "doc327", "doc334", "doc349", "doc359", "doc370", "doc374", "doc376", "doc385", "doc397", "doc407", ))


	[Test]
	public def TestQ51():
		RunTest("PREMIER not KHRUSHCHEV", ("doc100", "doc101", "doc108", "doc115", "doc116", "doc117", "doc121", "doc124", "doc141", "doc142", "doc153", "doc158", "doc159", "doc160", "doc169", "doc193", "doc194", "doc195", "doc197", "doc203", "doc209", "doc210", "doc213", "doc215", "doc219", "doc22", "doc221", "doc223", "doc224", "doc226", "doc227", "doc231", "doc235", "doc236", "doc237", "doc239", "doc241", "doc247", "doc25", "doc251", "doc256", "doc264", "doc277", "doc278", "doc28", "doc284", "doc285", "doc286", "doc287", "doc31", "doc313", "doc319", "doc320", "doc327", "doc33", "doc332", "doc34", "doc345", "doc347", "doc350", "doc351", "doc356", "doc359", "doc360", "doc37", "doc370", "doc373", "doc374", "doc377", "doc389", "doc390", "doc393", "doc394", "doc407", "doc413", "doc415", "doc43", "doc47", "doc55", "doc73", "doc78", "doc79", "doc8", "doc86", "doc88", "doc99", ))


	[Test]
	public def TestQ57():
		RunTest("PROVISIONS not TREATY", ("doc255", "doc422", ))


	[Test]
	public def TestQ60():
		RunTest("SIGNING and BAN and TREATY", ("doc306", "doc79", ))


	[Test]
	public def TestQ61():
		RunTest("NUCLEAR and WEAPONS and DEVELOPMENT", ("doc315", ))


	[Test]
	public def TestQ62():
		RunTest("MOSCOW or SUPPORT or AUTONOMY", ("doc1", "doc102", "doc104", "doc108", "doc111", "doc113", "doc114", "doc115", "doc121", "doc123", "doc128", "doc130", "doc133", "doc145", "doc146", "doc148", "doc156", "doc161", "doc169", "doc17", "doc170", "doc171", "doc172", "doc173", "doc185", "doc186", "doc190", "doc192", "doc193", "doc194", "doc195", "doc2", "doc20", "doc204", "doc207", "doc209", "doc21", "doc211", "doc216", "doc218", "doc22", "doc220", "doc225", "doc233", "doc235", "doc240", "doc247", "doc250", "doc252", "doc253", "doc254", "doc255", "doc261", "doc271", "doc274", "doc275", "doc277", "doc279", "doc289", "doc290", "doc293", "doc294", "doc295", "doc296", "doc298", "doc30", "doc304", "doc306", "doc307", "doc310", "doc315", "doc318", "doc32", "doc323", "doc326", "doc327", "doc328", "doc329", "doc33", "doc334", "doc341", "doc342", "doc343", "doc344", "doc345", "doc349", "doc350", "doc352", "doc353", "doc359", "doc360", "doc367", "doc374", "doc377", "doc378", "doc38", "doc382", "doc384", "doc385", "doc386", "doc387", "doc39", "doc390", "doc391", "doc396", "doc400", "doc403", "doc406", "doc418", "doc419", "doc422", "doc45", "doc47", "doc48", "doc50", "doc53", "doc56", "doc57", "doc58", "doc6", "doc70", "doc71", "doc78", "doc94", "doc95", "doc96", ))


	[Test]
	public def TestQ65():
		RunTest("BORDER and ISRAEL and SYRIA", ("doc100", "doc121", "doc194", "doc342", ))


	[Test]
	public def TestQ68():
		RunTest("INDIAN and COMMUNIST and CHINESE", ("doc155", "doc156", "doc307", "doc68", "doc92", ))

	
	public def RunTest(query as string, expected as (string)):
		qp = RetrievalSystem.CreateQueryProcessor()
		q as Query = QueryBuilder.Process(query, ParseDirection.ParseFromLeft)
		print q
		result = qp.ProcessQuery(q)
		
		// Make sure no unexpected documents were retrieved
		for doc in result:
			Assert.Contains(doc.Title, expected, "Result ${doc.Title} returned but not expected")
						
		// Make sure all expected documents were retrieved
		for docTitle in expected:
			Assert.AreNotEqual(null, result.Find({d as Document | d.Title == docTitle}), "Document ${docTitle} was not retrieved but was expected")