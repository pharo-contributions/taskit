accessing
name
	^ watchDog ifNil: [ name ] ifNotNil: [ watchDog name ]