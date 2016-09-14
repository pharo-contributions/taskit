as yet unclassified
scheduleTaskExecution: aTaskExecution
	
	poolWorker schedule: [ | worker |
		worker := self getAvailableWorker.
		worker schedule: [
			aTaskExecution value.
			self returnWorker: worker ] ]