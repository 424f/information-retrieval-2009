namespace IR

import System
import System.IO

class Document(IComparable[of Document], IComparable):
	[Getter(RetrievalSystem)] _RetrievalSystem as RetrievalSystem
	"""The retrieval system to which this document belongs"""
	
	[Getter(Id)] _Id as int
	"""Unique identifier for this instance"""
	
	[Property(Title)] _Title as string
	"""This document's title"""
	
	[Property(Path)] _Path as string
	"""The path where this document is located"""

	Words as int:
	"""Number of Words in this document (used for Heaps Law)"""
		get:
			return ReadContent().Split(char.Parse(' ')).Length
	
	[Property(NumTerms)] _NumTerms as int
	"""Overall number of terms that are part of this document (is set by DocumentProcessor)"""
	
	[Property(NumUniqueTerms)] _NumUniqueTerms as int
	"""Number of unique terms that are part of this document (is set by DocumentProcessor)"""
	
	static protected NumDocuments = 0
	
	public def constructor(retrievalSystem as RetrievalSystem, path as string):
		Path = path
		Title = IO.Path.GetFileName(path)
		_RetrievalSystem = retrievalSystem
		NumDocuments += 1
		_Id = NumDocuments
			
	public def ReadContent() as string:
		return File.ReadAllText(Path)

	public def CompareTo(other as Document) as int:
		return self.Title.CompareTo(other.Title)

	public def CompareTo(other as object) as int:
		return CompareTo(other as Document)

	public static def op_LessThan(d1 as Document, d2 as Document):
		return d1.CompareTo(d2) < 0
 