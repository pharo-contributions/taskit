run
run: aTKTTask onSuccess: aSuccessHandler onFailure: aFailureHandler onError: anErrorHandler
	[ processor run: aTKTTask onSuccess: aSuccessHandler onFailure: aFailureHandler ]
		on: Error
		do: [ :exception | anErrorHandler value: exception ]