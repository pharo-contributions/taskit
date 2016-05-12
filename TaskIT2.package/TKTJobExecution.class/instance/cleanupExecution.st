as yet unclassified
cleanupExecution
	runner := nil.
	taskExecution ifNotNil: [ taskExecution cleanupExecution ].
	taskExecution := nil.
	job := nil