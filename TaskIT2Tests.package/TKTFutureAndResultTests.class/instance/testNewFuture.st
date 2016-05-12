tests
testNewFuture
	| future |
	future := TKTFuture new.
	self deny: future isValueAvailable