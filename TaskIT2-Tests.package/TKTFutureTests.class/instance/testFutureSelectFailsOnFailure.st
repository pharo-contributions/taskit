tests-combinators
testFutureSelectFailsOnFailure

	| future got error |
	future := TKTFuture new.	
	(future select: [ :v | v even ]) onFailureDo: [ :v | got := v ].

	error := Error new.
	future deployFailure: error.
	
	self assert: got equals: error