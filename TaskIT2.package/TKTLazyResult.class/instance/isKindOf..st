testing
isKindOf: aClass
	^ self perform: #isKindOf: withArguments: {aClass}