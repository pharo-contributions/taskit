initialize
isLocalThreadActor
	^ runner ifNil: [ false ] ifNotNil: [ runner isLocalThreadRunner ]