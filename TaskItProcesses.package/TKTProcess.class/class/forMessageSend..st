instance creation
forMessageSend: aMessageSend
	^ self new
		messageSend: aMessageSend;
		yourself