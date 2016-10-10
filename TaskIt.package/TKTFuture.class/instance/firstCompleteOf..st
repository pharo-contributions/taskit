combinators
firstCompleteOf: anotherFuture
	
	| finished future |
	finished := false.
	future := TKTFuture new.
	future runner: runner.
	self onSuccessDo: [ :v |
		finished ifFalse: [
			finished := true.
			future deploySuccess: v ]].
	self onFailureDo: [ :v |
		finished ifFalse: [
			finished := true.
			future deployFailure: v freeze ]].
	anotherFuture onSuccessDo: [ :v |
		finished ifFalse: [
			finished := true.
			future deploySuccess: v ]].
	anotherFuture onFailureDo: [ :v |
		finished ifFalse: [
			finished := true.
			future deployFailure: v freeze ]].
	^ future