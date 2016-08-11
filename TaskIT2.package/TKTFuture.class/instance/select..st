combinators
select: aBlockClosure 
	
	| future |
	future := TKTFuture new.
	self onSuccessDo: [ :got | 
		[(aBlockClosure value: got)
			ifTrue: [ future deploySuccess: got ]
			ifFalse: [ future deployFailure: (NotFound new object: aBlockClosure) ] ]
				on: Error do: [ :e | future deployFailure: e ] ].
	self onFailureDo: [ :error | future deployFailure: error ].
	^ future