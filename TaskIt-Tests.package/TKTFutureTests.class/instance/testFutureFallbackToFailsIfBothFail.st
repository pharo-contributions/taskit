tests-combinators
testFutureFallbackToFailsIfBothFail
	| future got fallbackFuture error |
	future := TKTFuture new.
	fallbackFuture := TKTFuture new.
	(future fallbackTo: fallbackFuture) onFailureDo: [ :v | got := v ].
	error := Error new.
	[ error signal ]
		on: Error
		do: [ :e | fallbackFuture deployFailure: e ].
	future deployFailure: Error new.
	50 milliSecond wait.
	self assert: got equals: error