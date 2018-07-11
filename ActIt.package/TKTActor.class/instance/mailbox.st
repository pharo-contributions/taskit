accessing
mailbox
	^ self isWorkerActor 
		ifTrue: [ runner queue copy
				beReadOnlyObject;
				yourself ]
		ifFalse: [ nil ]