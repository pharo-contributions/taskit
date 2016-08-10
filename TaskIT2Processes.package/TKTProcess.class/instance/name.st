accessing
name
	^ 'Process: '
		, (messageSend ifNil: [ '' ] ifNotNil: [ '#' , messageSend selector , ' -> ' , messageSend receiver name ])