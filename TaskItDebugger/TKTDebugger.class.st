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

	^ super availableAutomatically and: [ self isEnabled ]
]

{ #category : #accessing }
TKTDebugger class >> defaultTitle [

	^ 'TaskIt'
]

{ #category : #accessing }
TKTDebugger class >> disable [

	IsEnabled := false
]

{ #category : #accessing }
TKTDebugger class >> enable [

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

	self isEnabled ifFalse: [ ^ false ].
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

{ #category : #accessing }
TKTDebugger class >> sessionClass [

	^ TKTDebugSession
]
