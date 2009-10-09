namespace IR

import System
import System.IO
import System.Collections.Generic

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
	
	static protected NumDocuments = 0
	
	public def constructor(retrievalSystem as RetrievalSystem, path as string):
		Path = path
		Title = IO.Path.GetFileName(path)
		_RetrievalSystem = retrievalSystem
		NumDocuments += 1
		_Id = NumDocuments
	
	public def Process(processor as IDocumentProcessor) as List[of Term]:
	"""Process the document to extract all terms in it"""
		return processor.Process(Path)
			
	public def ReadContent() as string:
		return File.ReadAllText(Path)

	public def CompareTo(other as Document) as int:
		return self.Title.CompareTo(other.Title)

	public def CompareTo(other as object) as int:
		return CompareTo(other as Document)

	public static def op_LessThan(d1 as Document, d2 as Document):
		return d1.CompareTo(d2) < 0
 