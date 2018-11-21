"
The service manager keeps a list of the currently installed tests and their state.
"
Class {
	#name : #TKTServiceManager,
	#superclass : #Object,
	#instVars : [
		'services'
	],
	#category : 'TaskIt-Services'
}

{ #category : #initialization }
TKTServiceManager >> initialize [

	super initialize.
	services := Set new.
]

{ #category : #purging }
TKTServiceManager >> purge [
	
	services := services select: [ :each | each isRunning ]
]

{ #category : #purging }
TKTServiceManager >> removeService: aService [

	services remove: aService ifAbsent: [  ].
]

{ #category : #accessing }
TKTServiceManager >> services [
	^ services
]

{ #category : #'start-stop' }
TKTServiceManager >> startService: aService [
	(services anySatisfy: [ :any | any name = aService name ])
		ifTrue: [ self
				error: ('A service named "{name}" is already registered' format: {('name' -> aService name)} asDictionary) ].
	aService launch.
	services add: aService
]

{ #category : #'start-stop' }
TKTServiceManager >> stopService: aService [

	aService requestStop
]
