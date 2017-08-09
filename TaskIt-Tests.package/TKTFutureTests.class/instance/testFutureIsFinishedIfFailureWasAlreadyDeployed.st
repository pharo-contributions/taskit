tests-termination
testFutureIsFinishedIfFailureWasAlreadyDeployed
	| future error |
	
	future := TKTFuture new.
	error := Error new.
	[ error signal ]
		on: Error
		do: [ :e | future deployFailure: e ].
	self assert: future isFinished