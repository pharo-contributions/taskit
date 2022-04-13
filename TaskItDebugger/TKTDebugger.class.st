"
I represent a debugger that can work with a virtual call stack composed of multiple processes.
"
Class {
	#name : #TKTDebugger,
	#superclass : #Object,
	#traits : 'TDebugger',
	#classTraits : 'TDebugger classTrait',
	#category : #TaskItDebugger
}

{ #category : #accessing }
TKTDebugger class >> defaultDebuggerRank [

	^ 10
]

{ #category : #accessing }
TKTDebugger class >> defaultTitle [

	^ 'TaskIt'
]

{ #category : #accessing }
TKTDebugger class >> disable [

	self availableAutomatically: false
]

{ #category : #accessing }
TKTDebugger class >> enable [

	self availableAutomatically: true
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

{ #category : #testing }
TKTDebugger class >> isEnabled [

	^ self availableAutomatically
]

{ #category : #accessing }
TKTDebugger class >> sessionClass [

	^ TKTDebugSession
]
