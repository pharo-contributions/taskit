accessing
job: aJob
	job
		ifNotNil: [ self error: 'You were configuring a: ' , job asString , ' and now you are trying to change to: ' , aJob asString ].
	job := aJob