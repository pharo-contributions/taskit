accessing
name
	^ process ifNil: [ name ] ifNotNil: [ process name ]