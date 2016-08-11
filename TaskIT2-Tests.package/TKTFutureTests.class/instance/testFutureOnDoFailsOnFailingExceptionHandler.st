tests-combinators
testFutureOnDoFailsOnFailingExceptionHandler

	| future got error |
	future := TKTFuture new.	
	error := Error new.
	(future on: Error do: [ :v | error signal ]) onFailureDo: [ :v | got := v ].

	future deployFailure: Error new.
	
	self assert: got equals: error