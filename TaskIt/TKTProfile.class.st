Class {
	#name : #TKTProfile,
	#superclass : #Object,
	#instVars : [
		'name',
		'runner',
		'process',
		'poolWorkerProcess',
		'errorHandler',
		'processProvider',
		'serviceManager',
		'debugging'
	],
	#category : #'TaskIt-Profiles'
}

{ #category : #'instance creation' }
TKTProfile class >> on: aDictionary [
	^ self new
		values: aDictionary;
		yourself
]

{ #category : #accessing }
TKTProfile >> activateProfile [
	self debugging
		ifTrue: [ self options
				do: [ :option | self assert: (self at: option) isDebuggingCompatible description: ('The option{1} is not debugging compatible! ' format: {option}) ].
			TKTDebugger enable ]
		ifFalse: [ TKTDebugger disable ].
	self runner start
]

{ #category : #accessing }
TKTProfile >> at: anEntry [
	^ self instVarNamed: anEntry asSymbol
]

{ #category : #accessing }
TKTProfile >> at: anEntry put: aValue [
	^ self instVarNamed: anEntry asSymbol put: aValue
]

{ #category : #accessing }
TKTProfile >> debugging [
	^ debugging
]

{ #category : #accessing }
TKTProfile >> debugging: anObject [
	debugging := anObject
]

{ #category : #accessing }
TKTProfile >> errorHandler [
	^ errorHandler
]

{ #category : #accessing }
TKTProfile >> errorHandler: anObject [
	errorHandler := anObject
]

{ #category : #accessing }
TKTProfile >> finalizeProfile [
	self options do: [ :option | self assert: (self at: option) finalize ]
]

{ #category : #accessing }
TKTProfile >> name [
	^ name
]

{ #category : #accessing }
TKTProfile >> name: anObject [
	name := anObject
]

{ #category : #accessing }
TKTProfile >> options [
	^ #(runner process poolWorkerProcess errorHandler processProvider serviceManager)
]

{ #category : #accessing }
TKTProfile >> poolWorkerProcess [
	^ poolWorkerProcess
]

{ #category : #accessing }
TKTProfile >> poolWorkerProcess: anObject [
	poolWorkerProcess := anObject
]

{ #category : #accessing }
TKTProfile >> process [
	^ process
]

{ #category : #accessing }
TKTProfile >> process: anObject [
	process := anObject
]

{ #category : #accessing }
TKTProfile >> processProvider [
	^ processProvider
]

{ #category : #accessing }
TKTProfile >> processProvider: anObject [
	processProvider := anObject
]

{ #category : #accessing }
TKTProfile >> runner [
	^ runner
]

{ #category : #accessing }
TKTProfile >> runner: anObject [
	runner := anObject
]

{ #category : #accessing }
TKTProfile >> serviceManager [
	^ serviceManager
]

{ #category : #accessing }
TKTProfile >> serviceManager: anObject [
	serviceManager := anObject
]

{ #category : #accessing }
TKTProfile >> values: aDictionary [
	aDictionary keysAndValuesDo: [ :k :v | self perform: ('{1}:' format: {k}) asSymbol withArguments: {v} ]
]
