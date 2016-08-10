scheduling
schedule: aTask
	
	poolWorker schedule: [ | worker |
		worker := self getAvailableWorker.
		worker schedule: [ 
			aTask value.
			self returnWorker: worker ] ].