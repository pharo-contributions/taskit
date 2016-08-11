tests-combinators
testFutureFallbackToHasSecondValueIfFirstFailsAndSecondSuccess

	| future got fallbackFuture |
	future := TKTFuture new.
	fallbackFuture := TKTFuture new.	

	(future fallbackTo: fallbackFuture) onSuccessDo: [ :v | got := v ].

	fallbackFuture deploySuccess: 2.
	future	 deployFailure: Error new.
	
	self assert: got equals: 2