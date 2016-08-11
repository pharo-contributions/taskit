tests-combinators
testFutureOnDoFailsOnTrappingWrongException

	| future got error |
	future := TKTFuture new.	
	(future on: NotFound do: [ :v | 5 ]) onFailureDo: [ :v | got := v ].

	error := Error new.
	future deployFailure: error.
	
	self assert: got equals: error