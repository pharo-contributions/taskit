constructor
receiver: anObject selector: aSelector
	^ self forMessageSend: (MessageSend receiver: anObject selector: aSelector)