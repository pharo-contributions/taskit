tests-combinators
testFutureFirstCompleteOfSuccessIfFirstSuccessFaster

	| future got secondFuture |
	future := TKTFuture new.
	secondFuture := TKTFuture new.
	
	(future firstCompleteOf: secondFuture) onSuccessDo: [ :v | got := v ].

	future deploySuccess: 5.
	secondFuture deployFailure: Error new.
	
	self assert: got equals: 5