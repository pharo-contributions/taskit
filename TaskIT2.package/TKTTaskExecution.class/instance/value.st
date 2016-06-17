accessing
value
	^ arguments isEmptyOrNil
		ifTrue: [ task valueOn: self ]
		ifFalse: [ self valueWithArguments: arguments ]