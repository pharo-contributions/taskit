accessing
value
	keepLooping := true.
	[ keepLooping ] whileTrue: [ super value ].
	onLoopFinalization ifNotNil: [ :v | v value ]