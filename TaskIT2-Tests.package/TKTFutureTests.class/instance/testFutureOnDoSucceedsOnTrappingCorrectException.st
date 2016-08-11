tests-combinators
testFutureOnDoSucceedsOnTrappingCorrectException

	| future got |
	future := TKTFuture new.	
	(future on: Error do: [ :v | 5 ]) onSuccessDo: [ :v | got := v ].

	future deployFailure: Error new.
	
	self assert: got equals: 5