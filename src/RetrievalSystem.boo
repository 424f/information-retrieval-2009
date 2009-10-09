namespace IR

import System
import System.IO
import System.Collections.Generic

struct Term(IComparable[of Term]):
	public ID as int
	
	public def CompareTo(other as Term) as int:
		return self.ID.CompareTo(other.ID)
		
	public override def Equals(other as object) as bool:
		return false if not other isa Term
		return self.ID == cast(Term, other).ID
	
	public override def GetHashCode() as int:
		return ID.GetHashCode()
	
class DocumentLoadedArgs(EventArgs):
	[Getter(Document)] _Document as Document
	[Getter(NumTerms)] _NumTerms as int
	
	public def constructor(document as Document, numTerms as int):
		_Document = document
		_NumTerms = numTerms

class TermOccurences(IComparable):
	[Property(Document)] _Document as Document
	[Property(Positions)] _Positions = List[of int]()
	
	public def CompareTo(other as object):
		Document.CompareTo(other)
		
class RetrievalSystem:
	protected Documents = List[of Document]()
	protected Index = Dictionary[of Term, List[of Document]]()
	protected PositionalIndex = Dictionary[of Term, List[of TermOccurences]]()
	protected Terms = Dictionary[of string, Term]()
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
			Stopwords[i] = GetTerm(stopwords[i].ToUpper().Trim())
		Array.Sort[of Term](Stopwords)
		
	public def IsStopword(term as Term):
		i = Array.BinarySearch[of Term](Stopwords, term)
		return i >= 0 and i < Stopwords.Length
		
	public def CreateIndex(directory as string):
		# Read all files
		dirInfo = DirectoryInfo(directory)
		files = dirInfo.GetFiles()
		_NumDocuments = files.Length
		for f in files:
			path = IO.Path.Combine(directory, f.Name)
			doc = Document(self, path)
			terms = doc.Process(DocumentProcessor)
			for term in terms:
				if not Index.ContainsKey(term):
					Index.Add(term, List[of Document]())
					PositionalIndex[term] = List[of TermOccurences]()
				Index[term].Add(doc)
			
			Documents.Add(doc)			
			DocumentLoaded(self, DocumentLoadedArgs(doc, terms.Count))
		# Sort indices
		for term in Index.Keys:
			Index[term].Sort()

	public def CreateQueryProcessor() as QueryProcessor:
		return QueryProcessor(self)

	public def RetrieveDocumentsForWord(word as string) as List[of Document]:
		term = GetTerm(word)
		return RetrieveDocumentsForTerm(term)
		
	public def RetrieveDocumentsForTerm(term as Term) as List[of Document]:
		if Index.ContainsKey(term):
			return Index[term]
		return List[of Document]()
	
	public def RetrieveDocumentsForTerm(termId as int) as List[of Document]:
		term = Term()
		term.ID = termId
		return RetrieveDocumentsForTerm(term)

	public def GetTerm(word as string) as Term:
		return NullTerm if word == null
		word = word.ToLower().Trim()
		if EnableStemming:
			word = PorterStemmer.stemTerm(word)
		if not Terms.ContainsKey(word):
			term = Term()
			term.ID = NumTerms
			_NumTerms += 1
			Terms.Add(word, term)
			Words.Add(term, word)
		return Terms[word]