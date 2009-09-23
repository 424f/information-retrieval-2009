class Document:
	[Property(Title)] _Title as string
	"""This document's title"""
	
	[Property(Path)] _Path as string
	"""The path where this document is located"""
	
	public def constructor(path as string):
		Path = path
	
	public def ReadContent() as string:
		return File.ReadAllText(Path)

		
		
print "Hello world"