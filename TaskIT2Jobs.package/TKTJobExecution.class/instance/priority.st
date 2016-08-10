accessing
priority
	^ priority ifNil: [ priority := Processor activePriority ]