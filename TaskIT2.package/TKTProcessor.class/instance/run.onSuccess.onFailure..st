as yet unclassified
run: aTKTTask onSuccess: aSuccessHandler onFailure: aFailureHandler
	self
		process: [ 
			[ aSuccessHandler value: aTKTTask value ]
				on: Error
				do: [ :exception | aFailureHandler value: exception ] ]