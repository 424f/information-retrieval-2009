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
			
	static public def BuildProximityQuery(rs as RetrievalSystem, query as string, proximity as int):
	"""Builds a query that is simply interpreted as a phrase query"""
		splitRule = regex("[^a-zA-Z0-9]")
		words = splitRule.Split(query)
		usedWords = List[of string]()
		for word in words:
			word = word.Trim()
			continue if word.Length == 0
			usedWords.Add(word)
		return ProximityQuery(usedWords.ToArray(), proximity)			
	
	static private def InterpretTerm(term as string) as Query:
		result as Query
		if term.StartsWith("\""): // Phrase query or proximity query
			term = term.Substring(1)
			if term.StartsWith("\\"):
				term = term.Substring(1)
				space = term.IndexOf(" ")
				proximity = int.Parse(term.Substring(0, space))
				result = ProximityQuery(term.Substring(space + 1), proximity)
			else:
				result = PhraseQuery(term.Substring(1))
		else:
			result = TermQuery(term)
		return result
				
	static public def BuildQuery(rs as RetrievalSystem, query as string, direction as ParseDirection):
	"""Query that consits of alternating keywords and operators and might also include phrase queries in quotes"""	
		items = List[of string]()
		item = ""
		query += " " // Trailing space makes it easier to parse
		inString = false
		for c in query:
			if c == char.Parse('"'):
				if inString:
					items.Add("\"${item}")
					item = ""
				else:
					pass
				inString = not inString
			elif not inString and char.IsWhiteSpace(c) and item.Length > 0:
				items.Add(item)
				item = ""
			else:
				item += c
		
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
		left as Query = InterpretTerm(items[0])
		i = 1
		while i + 1 < items.Count:
			op = items[i]
			term = items[i+1]
			right as Query = InterpretTerm(term)
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