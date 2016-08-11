combinators
zip: secondFuture
	
	| future |
	future := TKTFuture new.
	self
		onSuccessDo: [ :v1 | secondFuture
			onSuccessDo: [ :v2 | future deploySuccess: (Array with: v1 with: v2) ];
			onFailureDo: [ :e | future deployFailure: e ] ];
		onFailureDo: [ :e | future deployFailure: e ].
	^ future