tests-combinators
testFutureFlatCollectFailsOnMappedFutureFailure
	| future got error innerFuture |
	future := TKTFuture new.
	innerFuture := TKTFuture new.
	(future flatCollect: [ :v | innerFuture ]) onFailureDo: [ :v | got := v ].
	future deploySuccess: 2.
	error := Error new.
	[ error signal ]
		on: Error
		do: [ :e | innerFuture deployFailure: e ].
	50 milliSecond wait.
	self assert: got equals: error