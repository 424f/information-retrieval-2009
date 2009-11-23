namespace IR

import System	
import System.IO
import System.Collections.Generic

static class WordNet:	
	static Nouns as System.Collections.Generic.HashSet[of string]

	static def NounSynonyms(word as string):
	"""Returns noun synonyms of the most probable meaning"""
		if Nouns == null:
			Nouns = HashSet[of string]()
			f = File.OpenText("data/Nouns.txt")
			line = f.ReadLine()
			while line != null:
				Nouns.Add(line.Trim().ToUpper())
				line = f.ReadLine()
			f.Close()

		result = List[of string]()	
		if not Nouns.Contains(word.ToUpper()):
			return result
	
		word = word.Replace("\"", "\\\"")
		output = shell("wn", "\"${word}\" -synsn")
		for line in output.Split(("\r\n", "\n"), StringSplitOptions.RemoveEmptyEntries):
			line = line.Trim()
			if line.StartsWith("=> "):
				words = line.Substring("=> ".Length).Split(char.Parse(","))
				for word in words:
					word = word.Trim()
					result.Add(word)
				return result
		return result