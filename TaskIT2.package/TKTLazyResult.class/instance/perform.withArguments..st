message performing
perform: aSelector withArguments: anArray
	self class methodDictionary at: aSelector ifPresent: [ ^ super perform: aSelector withArguments: anArray ].
	^ future value perform: aSelector withArguments: anArray