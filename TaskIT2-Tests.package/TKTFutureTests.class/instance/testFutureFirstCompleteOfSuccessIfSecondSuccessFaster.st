tests-combinators
testFutureFirstCompleteOfSuccessIfSecondSuccessFaster

	| future got secondFuture |
	future := TKTFuture new.
	secondFuture := TKTFuture new.
	
	(future firstCompleteOf: secondFuture) onSuccessDo: [ :v | got := v ].

	secondFuture deploySuccess: 5.
	future deployFailure: Error new.
	
	self assert: got equals: 5