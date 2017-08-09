tests-combinators
testFutureFirstCompleteOfSuccessIfFirstSuccessFaster
	| future got secondFuture error |
	future := TKTFuture new.
	secondFuture := TKTFuture new.
	(future firstCompleteOf: secondFuture) onSuccessDo: [ :v | got := v ].
	future deploySuccess: 5.
	error := Error new.
	[ error signal ]
		on: Error
		do: [ :e | secondFuture deployFailure: e ].
	50 milliSecond wait.
	self assert: got equals: 5