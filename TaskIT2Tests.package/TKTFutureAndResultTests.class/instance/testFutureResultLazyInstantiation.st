tests
testFutureResultLazyInstantiation
	| future |
	future := TKTFuture new.
	self assert: future asResult thisObjectHash  = future asResult thisObjectHash