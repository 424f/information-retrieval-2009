namespace IR

import System
import System.IO
import System.Collections.Generic

interface IDocumentProcessor:
	def Process(document as Document)
	event ProcessedTerm as EventHandler[of ProcessedTermEventArgs]

class ProcessedTermEventArgs(EventArgs):
	[Getter(Term)] _Term as Term
	[Getter(Occurences)] _Occurences as List[of int]
	[Getter(Document)] _Document as Document
	
	def constructor(document as Document, term as Term, occurences as List[of int]):
		_Document = document
		_Term = term
		_Occurences = occurences

class DocumentProcessor(IDocumentProcessor):
"""Processes the text of a document according to certain rules"""
	static protected SplitRule = regex("[^a-zA-Z0-9]")
	protected RetrievalSystem as RetrievalSystem

	public event ProcessedTerm as EventHandler[of ProcessedTermEventArgs]

	public def constructor(retrievalSystem as RetrievalSystem):
		RetrievalSystem = retrievalSystem

	public virtual def Process(doc as Document):
	"""Processes the document text. Found terms and their occurences are reported using the ProcessedTerm event in lexicographic order"""
		lines = File.ReadAllLines(doc.Path)
		terms = List[of Term]()
		occurences = Dictionary[of Term, List[of int]]()
		pos = 0
		numTerms = 0
		for line in lines:
			words = SplitRule.Split(line)
			for word in words:
				word = word.Trim()
				continue if word.Length == 0
				term = RetrievalSystem.GetTerm(word, true)
				i = terms.BinarySearch(term)
				if i < 0:
					terms.Insert(~i, term)			
				if not occurences.ContainsKey(term):
					occurences[term] = List[of int]()
				occurences[term].Add(pos)
				
				# Fill in term frequency
				if not doc.TermFrequencies.ContainsKey(term):
					doc.TermFrequencies[term] = 0
				doc.TermFrequencies[term] += 1
				
				numTerms += 1
				pos += 1
		
		// Send event
		for term in terms:
			ProcessedTerm(self, ProcessedTermEventArgs(doc, term, occurences[term]))
			
		// Set document properties
		doc.NumTerms = numTerms
		doc.NumUniqueTerms = terms.Count