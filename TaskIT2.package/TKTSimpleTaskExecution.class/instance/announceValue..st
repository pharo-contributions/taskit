announce
announceValue: aValue
	onSuccess ifNotNil: [ :b | b cull: aValue cull: self ]