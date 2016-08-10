running
future: aTask
	
	| future |
	future := TKTFuture new.
	self schedule: [
		[ future deploySuccess: aTask value ] 
			on: Error
			do: [ :error | future deployFailure: error ] ].
	^ future