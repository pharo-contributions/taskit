accessing
name: aString
	name := aString.
	process ifNotNil: [ process name: aString ]