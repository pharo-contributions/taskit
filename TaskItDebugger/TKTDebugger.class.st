"
I represent a debugger that can work with a virtual call stack composed of multiple processes.
"
Class {
	#name : #TKTDebugger,
	#superclass : #GTGenericStackDebugger,
	#classVars : [
		'IsEnabled'
	],
	#category : 'TaskItDebugger'
}

{ #category : #testing }
TKTDebugger class >> availableAutomatically [
	^ self isEnabled
]

{ #category : #accessing }
TKTDebugger class >> defaultTitle [
	^ 'TaskIt'
]

{ #category : #accessing }
TKTDebugger class >> disable [
	self isEnabled
		ifFalse: [ ^ self ].
	IsEnabled := false.
	self unregister.
]

{ #category : #accessing }
TKTDebugger class >> enable [
	self isEnabled
		ifTrue: [ ^ self ].
	self register.
	IsEnabled := true
]

{ #category : #examples }
TKTDebugger class >> exampleFailure [
	<example>
	self enable.

	[ Object blah ] future onFailureDo: [ :ex | ex debug ]
]

{ #category : #testing }
TKTDebugger class >> handlesContext: aContext [
	^ aContext callChainAnySatisfy: [ :ctxt |
		ctxt receiver class = TKTProcess ]
]

{ #category : #initialization }
TKTDebugger class >> initialize [
	self enable
]

{ #category : #testing }
TKTDebugger class >> isEnabled [
	^ IsEnabled ifNil: [ IsEnabled := false ]
]

{ #category : #'tools registry' }
TKTDebugger class >> register [
	self registerToolsOn: Smalltalk tools
]

{ #category : #'tools registry' }
TKTDebugger class >> registerToolsOn: aToolRegistry [
	aToolRegistry
		registerDebugger: self
		withRank: 60
]

{ #category : #accessing }
TKTDebugger class >> sessionClass [
	^ TKTDebugSession
]

{ #category : #'tools registry' }
TKTDebugger class >> unregister [
	| entry |
	entry := Smalltalk tools debuggers
		detect: [ :association | association key = self ]
		ifNone: [ ^ self ].
		
	Smalltalk tools debuggers remove: entry
]
