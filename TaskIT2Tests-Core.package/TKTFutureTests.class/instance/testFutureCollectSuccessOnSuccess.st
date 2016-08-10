tests-combinators
testFutureCollectSuccessOnSuccess

	| future got |
	future := TKTFuture new.	

	(future collect: [ :v | v * 5 ]) onSuccessDo: [ :v | got := v ].
	
	future deploySuccess: 2.
	
	self assert: got equals: 10