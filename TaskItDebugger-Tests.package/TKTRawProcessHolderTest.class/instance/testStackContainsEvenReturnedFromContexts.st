tests
testStackContainsEvenReturnedFromContexts
	"The stack must contain all contexts, even those already returned from"
	| process |
	process := self newRawProcess.
	
	self assert: (process masterProcessHolder stack contains: [ :context |
		context selector = #newRawProcess and: [
			context methodClass = self class ] ])