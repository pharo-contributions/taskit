accesing
priority
	^ priority ifNil: [ priority := Processor activePriority ]