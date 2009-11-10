namespace IR

import System	
import System.Collections.Generic

static class WordNet:	
	static def NounSynonyms(word as string):
	"""Returns noun synonyms of the most probable meaning"""
		word = word.Replace("\"", "\\\"")
		output = shell("wn", "\"${word}\" -synsn")
		result = List[of string]()
		for line in output.Split(("\r\n", "\n"), StringSplitOptions.RemoveEmptyEntries):
			line = line.Trim()
			if line.StartsWith("=> "):
				words = line.Substring("=> ".Length).Split(char.Parse(","))
				for word in words:
					word = word.Trim()
					result.Add(word)
				return result
		return result