tools registry
unregister
	| entry |
	entry := Smalltalk tools debuggers
		detect: [ :association | association key = self ]
		ifNone: [ ^ self ].
		
	Smalltalk tools debuggers remove: entry