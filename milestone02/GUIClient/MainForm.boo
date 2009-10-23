namespace GUIClient

import System
import System.Collections
import System.Drawing
import System.Windows.Forms
import IR

partial class MainForm:
	public RetrievalSystem = RetrievalSystem()
	
	public def constructor():
		// The InitializeComponent() call is required for Windows Forms designer support.
		InitializeComponent()
	
	private def BuildIndexButtonClick(sender as object, e as System.EventArgs):
		RetrievalSystem = RetrievalSystem()
		RetrievalSystem.EnableStemming = EnablePorterStemming.Checked
		if EnableStopwordElimination.Checked:
			RetrievalSystem.LoadStopwords("../data/stopwords.txt")
		RetrievalSystem.DocumentLoaded += def():
			BuildProgress.Maximum = RetrievalSystem.NumDocuments
			BuildProgress.Value += 1
		BuildProgress.Value = 0
		RetrievalSystem.CreateIndex("../data/TIME/Docs/")
	
		// Create some statistics
		# Size of the term-document matrix (assuming we had one)
		StatsText.Text = ""
		StatsText.Text += "Term-document matrix size:" + "\r\n"
		StatsText.Text += "  ${RetrievalSystem.NumDocuments} x ${RetrievalSystem.NumTerms} = ${RetrievalSystem.NumDocuments*RetrievalSystem.NumTerms}" + "\r\n"
		
		longestPostingList = RetrievalSystem.RetrieveDocumentsForTerm(0).Count 
		shortestPostingList = longestPostingList
		StatsText.Text += "Number of 1s in this matrix:" + "\r\n"
		numOnes = 0
		for i in range(RetrievalSystem.NumTerms):
			numDocuments = RetrievalSystem.RetrieveDocumentsForTerm(i).Count
			numOnes += numDocuments
			longestPostingList = Math.Max(longestPostingList, numDocuments)
			shortestPostingList = Math.Min(shortestPostingList, numDocuments)
		StatsText.Text += "  ${numOnes} (which means ${cast(single, numOnes) / RetrievalSystem.NumDocuments / RetrievalSystem.NumTerms}%)" + "\r\n"
		
		StatsText.Text += "Longest posting list:" + "\r\n"
		StatsText.Text += "  ${longestPostingList} document(s) (that's quite a lot)" + "\r\n"
		
		StatsText.Text += "Shortest posting list:" + "\r\n"
		StatsText.Text += "  ${shortestPostingList} document(s)" + "\r\n"
		
		StatsText.Text += "Heaps Law:" + "\r\n"
		StatsText.Text += "  k=" + RetrievalSystem.ComputeHeapsLawK() + "\r\n"

		// Find probably invalid words		
		StatsText.Text += "10 probably invalid words:" + "\r\n"
		oneWords = List[of String]()
		for word in RetrievalSystem.Terms.Keys:
			if RetrievalSystem.RetrieveDocumentsForWord(word).Count == 1:
				oneWords.Add(word)
		oneWords.Sort({w1 as string, w2 as string | -w1.Length.CompareTo(w2.Length)})		
		for word in oneWords.GetRange(0, 10):
			StatsText.Text += "  - " + word + " " + "\r\n"
	
	private def SearchButtonClick(sender as object, e as System.EventArgs):
		try:
			qp = RetrievalSystem.CreateQueryProcessor()
			q as Query = QueryBuilder.BuildQuery(RetrievalSystem, SearchText.Text, ParseDirection.ParseFromLeft)
			result = qp.ProcessQuery(q)
			SearchResultsText.Text = ""
			for doc in result:
				SearchResultsText.Text += doc.Title + "\r\n"
		except e:
			SearchResultsText.Text = e.ToString()
[STAThread]
public def Main(argv as (string)) as void:
	Application.EnableVisualStyles()
	Application.SetCompatibleTextRenderingDefault(false)
	Application.Run(MainForm())

