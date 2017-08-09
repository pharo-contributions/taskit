combinators
recoverWith: aBlock
	
	| future |
	future := TKTFuture new.
	future runner: runner.
	self onSuccessDo: [ :value | future deploySuccess: value ].
	self onFailureDo: [ :error | | recoverFuture |
		recoverFuture := aBlock value: error.
		recoverFuture onSuccessDo: [ :value | future deploySuccess: value ].
		recoverFuture onFailureDo: [ :value | future deployFailure: value freeze ] ].	
	^ future