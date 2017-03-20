tests-combinators
testFutureAndThenFailsIfFirstFails
	| future collection thenFuture got error |
	future := TKTFuture new.
	collection := OrderedCollection new.
	thenFuture := future
		andThen: [ :v | collection add: v + 1 ];
		andThen: [ :v | collection add: v + 2 ];
		andThen: [ :v | collection add: v + 3 ].
	thenFuture onFailureDo: [ :e | got := e ].
	error := Error new.
	[ error signal ]
		on: Error
		do: [ :e | future deployFailure: e ].
	50 milliSecond wait.
	self assert: got equals: error