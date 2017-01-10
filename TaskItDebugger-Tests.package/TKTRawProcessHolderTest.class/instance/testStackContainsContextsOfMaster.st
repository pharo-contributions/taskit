tests
testStackContainsContextsOfMaster
	| process |
	process := self newRawProcess.

	thisContext stack do: [ :context |
		self assert: (process masterProcessHolder stack identityIncludes: context) ].