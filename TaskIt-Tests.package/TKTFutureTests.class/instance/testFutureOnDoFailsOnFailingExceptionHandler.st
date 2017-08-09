tests-combinators
testFutureOnDoFailsOnFailingExceptionHandler
	| future got error error2 |
	future := TKTFuture new.
	error := Error new.
	(future
		on: Error
		do: [ :v | error signal ]) onFailureDo: [ :v | got := v ].
	error2 := Error new.
	[ error2 signal ]
		on: Error
		do: [ :e | future deployFailure: e ].
	50 milliSecond wait.
	self assert: got equals: error