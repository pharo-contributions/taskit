tests-combinators
testFutureSelectFailsOnFailure
	| future got error |
	future := TKTFuture new.
	(future select: [ :v | v even ]) onFailureDo: [ :v | got := v ].
	error := Error new.
	[ error signal ]
		on: Error
		do: [ :e | future deployFailure: e ].
	50 milliSecond wait.
	self assert: got equals: error