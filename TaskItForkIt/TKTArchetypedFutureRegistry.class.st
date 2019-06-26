Class {
	#name : #TKTArchetypedFutureRegistry,
	#superclass : #TKTServerDelegate,
	#instVars : [
		'futures',
		'server',
		'top'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #registry }
TKTArchetypedFutureRegistry >> register: aFuture [
	futures add: aFuture
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> registerBackend: aRequest [
	self halt. 
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> start [
	server ifNotNil: [ ^ self ].
	server := ZnServer on: 0
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> stop [
	server
		ifNotNil: [ server stop.
			server := nil ]
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> top: aMainRunner [
	top := aMainRunner
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> url [
	^ server localUrl
]
