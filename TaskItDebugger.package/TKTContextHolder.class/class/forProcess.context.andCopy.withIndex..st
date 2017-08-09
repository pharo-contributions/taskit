instance creation
forProcess: aProcess context: originalContext andCopy: copyContext withIndex: anInteger
	^ self new
		initializeWithProcess: aProcess
			context: originalContext
			andCopy: copyContext
			withIndex: anInteger;
		yourself