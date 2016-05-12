tests
testStickyFutureResultLazyInstantiation
	
	| future |
	future := TKTFuture new.
	
	self assert: future asResult hash = future asResult hash.
	