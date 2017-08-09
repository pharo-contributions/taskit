tests-combinators
testFutureZipFailsIfSecondFails

	| future zipFuture got error |
	future := TKTFuture new.
	zipFuture := TKTFuture new.
	
	(future zip: zipFuture) onFailureDo: [ :tuple | got := tuple ].

	error := Error new.
	[ error signal ]
		on: Error
		do: [ :e | zipFuture deployFailure: e ].

	future deploySuccess: 5.
	50 milliSecond wait.
	
	self assert: got equals: error