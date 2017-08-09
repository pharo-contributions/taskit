tests-combinators
testFutureFirstCompleteOfFailsIfFirstFailsFaster

	| future got secondFuture error |
	future := TKTFuture new.
	secondFuture := TKTFuture new.
	
	(future firstCompleteOf: secondFuture) onFailureDo: [ :v | got := v ].

	error := Error new.
	[ error signal ]
		on: Error
		do: [ :e | future deployFailure: e ].
	secondFuture deploySuccess: 1.
	50 milliSecond wait.

	self assert: got equals: error