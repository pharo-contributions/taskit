iterating
next
	
	self isDone ifTrue: [ self error: 'retries finished' ].
	^ nextRetryBlock value