accessing
processClass
	^ processClass ifNil: [ processClass := TKTWorkerProcess ]