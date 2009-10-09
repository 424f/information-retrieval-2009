namespace IR

import System
import System.Collections.Generic

class QueryBuilder:
	static public def BuildPhraseQuery(rs as RetrievalSystem, query as string):
	"""Builds a query that is simply interpreted as a phrase query"""
		splitRule = regex("[^a-zA-Z0-9]")
		words = splitRule.Split(query)
		usedWords = List[of string]()
		for word in words:
			word = word.Trim()
			continue if word.Length == 0
			usedWords.Add(word)
		return PhraseQuery(usedWords.ToArray())
			
			
	
	static public def BuildQuery(rs as RetrievalSystem, query as string, direction as ParseDirection):
	"""Query that consits of alternating keywords and operators"""
		items = List[of string](query.Split((Char.Parse(' '),), StringSplitOptions.RemoveEmptyEntries))
		
		# Remove all stopwords
		i = 0
		while i < items.Count:
			if rs.IsStopword(rs.GetTerm(items[i])):
				items.RemoveRange(i, (2 if i + 1 < items.Count else 1))
				continue
			i += 2
		
		if items.Count == 0:
			return TermQuery(null)
		
		# Reverse for parsing from right
		if direction == ParseDirection.ParseFromRight:
			items.Reverse()
		
		# Match a term
		left as Query = TermQuery(items[0])
		i = 1
		while i + 1 < items.Count:
			op = items[i]
			term = items[i+1]
			right = TermQuery(term)
			if op == "not":
				left = NotQuery(left, right)
			elif op == "and":
				left = AndQuery(left, right)
			elif op == "or":
				left = OrQuery(left, right)
			else:
				raise Exception("Unknown operator '${op}'")	
			i += 2
		
		if i < items.Count:
			raise Exception("Leftover expression ${items[items.Count-1]}")
			
		return left