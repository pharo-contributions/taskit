tests-combinators
testFutureFlatCollectFailsOnSelfFailure

	| future got error innerFuture |
	future := TKTFuture new.	
	innerFuture := TKTFuture new.
	(future flatCollect: [ :v | innerFuture ]) onFailureDo: [ :v | got := v ].
	
	error := Error new.
	future deployFailure: error. 
	
	self assert: got equals: error