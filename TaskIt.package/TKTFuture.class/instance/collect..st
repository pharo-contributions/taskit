combinators
collect: aBlockClosure 
	
	| future |
	future := TKTFuture new.
	future runner: runner.
	self onSuccessDo: [ :got | 
		[ future deploySuccess: (aBlockClosure value: got) ]
			on: Error do: [ :e | future deployFailure: e freeze ] ].
	self onFailureDo: [ :error | future deployFailure: error freeze ].
	^ future