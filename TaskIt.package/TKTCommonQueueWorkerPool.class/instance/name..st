accessing
name: aString
	name := aString.
	watchDog ifNotNil: [ watchDog name: name , '-WatchDog' ]