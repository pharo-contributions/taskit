"
A lightweight for development.
"
Class {
	#name : #TKTLightweightProfile,
	#superclass : #TKTProfile,
	#category : #TaskItProcesses
}

{ #category : #private }
TKTLightweightProfile class >> priority [

	^ -1
]

{ #category : #accessing }
TKTLightweightProfile class >> profileName [
	
	^ #lightweight
]

{ #category : #private }
TKTLightweightProfile class >> profileValues [

	^ {(#debugging -> false).
		(#runner -> TKTWorker createDefault ).
		(#poolWorkerProcess -> TKTWorkerProcess).
		(#process -> Process).
		(#errorHandler -> TKTExceptionHandler).
		(#watchDog -> TKTWatchDog onDuty).
		(#processProvider -> TKTTaskItProcessProvider new).
		(#serviceManager -> TKTServiceManager new)} asDictionary
]
