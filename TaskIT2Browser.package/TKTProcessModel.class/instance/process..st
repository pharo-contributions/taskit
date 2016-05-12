accessing
process: aTktProcess
	| messageSend |
	process := aTktProcess.
	task := (aTktProcess annotation: #task)
		ifNotNil: [ :t | 
			messageSend := t task messageSend.
			t ].
	messageSend := messageSend ifNil: [ aTktProcess messageSend ].
	messageSend
		ifNotNil: [ :ms | 
			receiver := ms receiver.
			selector := ms selector.
			arguments := ms arguments ].
	job := aTktProcess annotation: #job