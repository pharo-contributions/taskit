initialize
isUIActor
	^ runner ifNil: [ false ] ifNotNil: [ runner isUIRunner ]