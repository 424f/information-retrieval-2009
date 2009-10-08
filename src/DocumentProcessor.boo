namespace IR

import System
import System.IO
import System.Collections.Generic

interface IDocumentProcessor:
	def Process(path as string) as List[of Term]

class DocumentProcessor(IDocumentProcessor):
"""Processes the text of a document according to certain rules"""
	static protected SplitRule = regex("[^a-zA-Z0-9]")
	protected RetrievalSystem as RetrievalSystem

	public def constructor(retrievalSystem as RetrievalSystem):
		RetrievalSystem = retrievalSystem

	public virtual def Process(path as string) as List[of Term]:
		lines = File.ReadAllLines(path)
		terms = List[of Term]()
		for line in lines:
			words = SplitRule.Split(line)
			for word in words:
				word = word.Trim()
				continue if word.Length == 0
				term = RetrievalSystem.GetTerm(word)
				i = terms.BinarySearch(term)
				if i < 0:
					terms.Insert(~i, term)						
		return terms		