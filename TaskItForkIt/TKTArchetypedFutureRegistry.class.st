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
TKTArchetypedFutureRegistry >> initialize [
	super initialize.
	self
		map: 'registerBackend' to: #registerBackend:;
		map: 'deployFutureResult' to: #deployFutureResult:
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> register: aFuture [
	futures add: aFuture
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> registerBackend: aRequest [
	| arrayUrlHash |
	arrayUrlHash := (STONReader on: aRequest entity string readStream) next.
	top
		noteRemoteWorkerAt: arrayUrlHash first
		forBackendHashed: arrayUrlHash second
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> start [
	^ server
		ifNil: [ server := ZnSingleThreadedServer on: 0.
			server bindingAddress: NetNameResolver loopBackAddress.
			server delegate: self.
			server start.
			self assert: server isRunning & server isListening ]
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> top: aMainRunner [
	top := aMainRunner
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> url [
	self assert: server isRunning & server isListening.
	^ server localUrl
]
