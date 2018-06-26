instance-creation
createProcessDoing: aValuable
	| toFork |
	toFork := aValuable isBlock
		ifTrue: [ aValuable ]
		ifFalse: [ [ aValuable value ] ].
	^ toFork fork