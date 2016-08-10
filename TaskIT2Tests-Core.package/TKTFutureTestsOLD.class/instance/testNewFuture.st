tests
testNewFuture
	| future |
	future := TKTFutureOLD new.
	self deny: future isValueAvailable