schedulling
future: aTask
	
	| future |
	future := TKTFuture new.
	future runner: self.
	self schedule: [
		[ future deploySuccess: aTask value ] 
			on: Error
			do: [ :error | future deployFailure: error ] ].
	^ future