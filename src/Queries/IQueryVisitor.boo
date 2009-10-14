namespace IR

import System

interface IQueryVisitor:
	def VisitAndQuery(andQuery as AndQuery)
	def VisitOrQuery(orQuery as OrQuery)
	def VisitNotQuery(notQuery as NotQuery)
	def VisitTermQuery(termQuery as TermQuery)
	def VisitProximityQuery(proximityQuery as ProximityQuery)