combinators
flatCollect: aBlockClosure 
	
	| future |
	future := TKTFuture new.
	future runner: runner.
	self onSuccessDo: [ :got | [(aBlockClosure value: got)
		onSuccessDo: [ :got2 | future deploySuccess: got2 ];
		onFailureDo: [ :error | future deployFailure: error freeze ]]
				on: Exception do: [ :e | future deployFailure: e freeze ] ].
	self onFailureDo: [ :error | future deployFailure: error freeze ].
	^ future