tests-combinators
testFutureFlatCollectFailsOnSelfFailure
	| future got error innerFuture |
	future := TKTFuture new.
	innerFuture := TKTFuture new.
	(future flatCollect: [ :v | innerFuture ]) onFailureDo: [ :v | got := v ].
	error := Error new.
	[ error signal ]
		on: Error
		do: [ :e | future deployFailure: e ].
	50 milliSecond wait.
	self assert: got equals: error