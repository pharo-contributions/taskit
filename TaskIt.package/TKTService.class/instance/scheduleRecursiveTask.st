starting
scheduleRecursiveTask 

	stopRequested
		ifTrue: [ worker schedule: [ self doStop ] ]
		ifFalse: [
			worker schedule: [ 
				self iterateService.
				self scheduleRecursiveTask ]]