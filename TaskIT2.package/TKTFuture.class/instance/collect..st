combinators
collect: aBlockClosure 
	
	| future |
	future := TKTFuture new.
	self onSuccessDo: [ :got | future deploySuccess: (aBlockClosure value: got) ].
	self onFailureDo: [ :error | future deployFailure: error ].
	^ future