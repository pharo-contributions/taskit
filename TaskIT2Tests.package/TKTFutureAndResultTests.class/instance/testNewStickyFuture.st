tests
testNewStickyFuture
	| future |
	future := TKTFuture new.
	
	self deny: future isValueAvailable.
	