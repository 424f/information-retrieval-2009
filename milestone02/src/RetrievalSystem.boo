namespace IR

import System
import System.IO
import System.Collections.Generic
	
class DocumentLoadedArgs(EventArgs):
	[Getter(Document)] _Document as Document
	[Getter(NumTerms)] _NumTerms as int
	
	public def constructor(document as Document, numTerms as int):
		_Document = document
		_NumTerms = numTerms

class TermOccurences(IComparable):
	[Property(Document)] _Document as Document
	[Property(Occurences)] _Occurences as IEnumerable[of int]
	
	public def constructor(document as Document, occurences as IEnumerable[of int]):
		_Document = document
		_Occurences = occurences
	
	public def CompareTo(other as object):
		Document.CompareTo(other)
		
class RetrievalSystem:
	protected Documents = List[of Document]()
	protected Index = Dictionary[of Term, List[of Document]]()
	protected PositionalIndex = Dictionary[of Term, List[of TermOccurences]]()
	protected InverseDocumentFrequency = Dictionary[of Term, double]()
	[Getter(Terms)] _Terms = Dictionary[of string, Term]()
	protected Words = Dictionary[of Term, string]()
	protected Stopwords = array(Term, 0)
	public DocumentProcessor as IDocumentProcessor
	[Getter(NumTerms)] _NumTerms = 0
	[Getter(NumDocuments)] _NumDocuments = 0
	protected PorterStemmer = PorterStemmerAlgorithm.PorterStemmer()
	
	[Property(EnableStemming)] _EnableStemming = false
	
	public NullTerm:
		get: return _NullTerm
	private _NullTerm as Term

	public event DocumentLoaded as EventHandler[of DocumentLoadedArgs]
	
	public def constructor():
		DocumentProcessor = DocumentProcessor(self)
		
		// Create a null term that never occurs in any document
		_NullTerm = Term()
		_NullTerm.ID = NumTerms
		_NumTerms += 1		
		
	public def LoadStopwords(path as string):
		stopwords = File.ReadAllLines(path)
		Stopwords = array(Term, stopwords.Length)
		for i in range(stopwords.Length):
			Stopwords[i] = GetTerm(stopwords[i].ToUpper().Trim(), true)
		Array.Sort[of Term](Stopwords)
		
	public def IsStopword(term as Term):
		i = Array.BinarySearch[of Term](Stopwords, term)
		return i >= 0 and i < Stopwords.Length

	def OnProcessedTerm(sender as object, e as ProcessedTermEventArgs) as void:
		term = e.Term
		if not Index.ContainsKey(term):
			Index.Add(term, List[of Document]())
			PositionalIndex[term] = List[of TermOccurences]()
		PositionalIndex[term].Add(TermOccurences(e.Document, e.Occurences))
		Index[term].Add(e.Document)
		
	public def CreateIndex(directory as string):
		# Calculate document frequency for each term
		df = Dictionary[of Term, int]()
		DocumentProcessor.ProcessedTerm += def(sender as object, e as ProcessedTermEventArgs):
			if not df.ContainsKey(e.Term):
				df[e.Term] = 0
			df[e.Term] += 1
		
		DocumentProcessor.ProcessedTerm += OnProcessedTerm
		# Read all files
		dirInfo = DirectoryInfo(directory)
		files = dirInfo.GetFiles()
		_NumDocuments = files.Length
		for f in files:
			path = IO.Path.Combine(directory, f.Name)
			doc = Document(self, path)
			DocumentProcessor.Process(doc)
			Documents.Add(doc)			
			DocumentLoaded(self, DocumentLoadedArgs(doc, 0))
		# Sort indices
		for term in Index.Keys:
			Index[term].Sort()
		DocumentProcessor.ProcessedTerm -= OnProcessedTerm

		# Calculate inverse document frequency
		for term in df.Keys:
			InverseDocumentFrequency[term] = Math.Log10(NumDocuments / df[term])

	public def CreateQueryProcessor() as QueryProcessor:
		return QueryProcessor(self)

	public def RetrieveDocumentsForWord(word as string) as List[of Document]:
		term = GetTerm(word, false)
		return RetrieveDocumentsForTerm(term)
		
	public def RetrieveDocumentsForTerm(term as Term) as List[of Document]:
		if Index.ContainsKey(term):
			return Index[term]
		return List[of Document]()
	
	public def RetrieveDocumentsForTerm(termId as int) as List[of Document]:
		term = Term()
		term.ID = termId
		return RetrieveDocumentsForTerm(term)
		
	public def RetrievePositionsForTermInDocument(term as Term, doc as Document) as List[of int]:
		return PositionalIndex[term].Find({ to as TermOccurences | to.Document == doc }).Occurences

	public def GetTerm(word as string, create as bool) as Term:
		return NullTerm if word == null 
		word = word.ToLower().Trim()
		if EnableStemming:
			word = PorterStemmer.stemTerm(word)
		if not Terms.ContainsKey(word):
			return NullTerm if not create
			term = Term()
			term.ID = NumTerms
			_NumTerms += 1
			Terms.Add(word, term)
			Words.Add(term, word)
		return Terms[word]
	
	public def ComputeHeapsLawK() as int:
		beta = 0.5
		V = Terms.Count
		totalWordCount = 0
		for document as Document in Documents:
			totalWordCount += document.NumTerms
		
		return (V/(totalWordCount**beta))
		
	public def ExecuteQuery(query as string, includeZeroScore as bool) as List[of QueryResult]:
	"""Executes a query consisting of possibly multiple words. For vector space queries, we can ignore QueryBuilder and QueryProcessor for now
	We use:
		Term frequency: Logarithm (1 + log(tf_td))
		Document frequency: idf (log(N / df_t))
		Normalization: 1 / sqrt(sum(wi*wi))
	"""
		splitRule = regex("[^a-zA-Z0-9]")
		words = splitRule.Split(query)
		
		result = List[of QueryResult]()
		for document in Documents:
			score = 0.0
			sqrWeightSum = 0.0
			for word in words:
				term = GetTerm(word, false)
				if term == NullTerm:
					continue

				if document.TermFrequencies.ContainsKey(term):
					weight = (1.0 + Math.Log10(document.TermFrequencies[term])) * InverseDocumentFrequency[term]
					sqrWeightSum += weight*weight
					score += weight
		
			if score > 0.0 or includeZeroScore:
				result.Add(QueryResult(document, score / Math.Sqrt(sqrWeightSum)))
		result.Sort()
		return result
					
	
