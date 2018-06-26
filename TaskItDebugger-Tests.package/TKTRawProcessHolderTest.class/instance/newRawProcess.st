helpers
newRawProcess
	| dummyObject messageSend process raw |
	dummyObject := Dictionary new.
	messageSend := MessageSend receiver: dummyObject selector: #at:put: arguments: {'key' . 'value'}.
	process := TKTProcess forMessageSend: messageSend.
	TKTConfiguration
		process: TKTRawProcess
		during: [ raw := process privateCreatePharoProcess
				resume;
				yourself ].
	^ raw