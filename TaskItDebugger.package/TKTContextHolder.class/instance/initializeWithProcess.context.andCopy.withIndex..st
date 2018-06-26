initialization
initializeWithProcess: aProcess context: originalContext andCopy: copyContext withIndex: anInteger
	process := aProcess.
	original := WeakArray with: originalContext.
	copy := WeakArray with: copyContext.
	index := anInteger