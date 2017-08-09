helpers
newRawProcess
	| dummyObject messageSend process |
	dummyObject := Dictionary new.
	messageSend := MessageSend
		receiver: dummyObject
		selector: #at:put: 
		arguments: {'key'.	'value'}.
	process := TKTProcess forMessageSend: messageSend.
	^ process privateCreatePharoProcess
		resume;
		yourself