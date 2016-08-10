accessing
next
	^ blocking
		ifTrue: [ queue next ]
		ifFalse: [ queue nextOrNil ]