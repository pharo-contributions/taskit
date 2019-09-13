Extension { #name : #Win32Environment }

{ #category : #'*TaskIt-QueueBackend' }
Win32Environment >> getPid [ 

	^self ffiCall: #(int _getpid())	module: LibC
]
