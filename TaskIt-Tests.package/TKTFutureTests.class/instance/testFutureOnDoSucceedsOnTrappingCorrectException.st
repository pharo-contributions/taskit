tests-combinators
testFutureOnDoSucceedsOnTrappingCorrectException
	| future got error |
	future := TKTFuture new.
	(future
		on: Error
		do: [ :v | 5 ]) onSuccessDo: [ :v | got := v ].
	error := Error new.
	[ error signal ]
		on: Error
		do: [ :e | future deployFailure: e ].
	50 milliSecond wait.
	self assert: got equals: 5