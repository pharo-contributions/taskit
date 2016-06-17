evaluating
valueWithArguments: aSequenceOfArguments
	keepLooping := true.
	[ keepLooping ] whileTrue: [ super valueWithArguments: aSequenceOfArguments ].
	onLoopFinalization ifNotNil: [ :v | v value ]