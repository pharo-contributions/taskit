tests-combinators
testFutureSelectFailsOnNonSatisfyingCondition

	| future got |
	future := TKTFuture new.	
	(future select: [ :v | v even ]) onFailureDo: [ :v | got := v ].
	
	future deploySuccess: 3.
	
	self assert: (got isKindOf: NotFound)