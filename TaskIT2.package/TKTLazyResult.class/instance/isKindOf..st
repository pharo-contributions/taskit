forwarding
isKindOf: aClass
	^ self perform: #isKindOf: withArguments: {aClass}