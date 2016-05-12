value waiting
wait
	self isValueAvailable
		ifTrue: [ ^ self ].
	semaphore wait