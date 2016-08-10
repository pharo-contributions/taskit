tests-combinators
testFutureCollectFailsOnFailure

	| future got error |
	future := TKTFuture new.	

	(future collect: [ :v | v * 5 ]) onFailureDo: [ :v | got := v ].
	
	error := Error new.
	future deployFailure: error.
	
	self assert: got equals: error