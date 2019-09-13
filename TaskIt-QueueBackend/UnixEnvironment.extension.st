Extension { #name : #UnixEnvironment }

{ #category : #'*TaskIt-QueueBackend' }
UnixEnvironment >> getPid [ 

	^self ffiCall: #(int getpid())	module: LibC
]
