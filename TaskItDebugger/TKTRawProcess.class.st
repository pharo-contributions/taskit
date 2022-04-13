"
I represent a process that is not critical to the system. In POSIX terms, instances of me are threads.

My main purpose is to ensure that a link exists to the process that created me. In this relationship I am called ""slave"" and my creator is called ""master"". This link can be used by debuggers to display my call stack augmented with the activation records from my master.

Send #newTaskItProcess to a block to create instances of me:

[ self makeJuice ] newTaskItProcess resume
"
Class {
	#name : #TKTRawProcess,
	#superclass : #Process,
	#instVars : [
		'masterProcessHolder'
	],
	#category : #TaskItDebugger
}

{ #category : #configuration }
TKTRawProcess class >> disableDebugger [
	TKTDebugger disable
]

{ #category : #configuration }
TKTRawProcess class >> enableDebugger [
	TKTDebugger enable
]

{ #category : #configuration }
TKTRawProcess class >> isDebuggingCompatible [
	^ true
]

{ #category : #initialization }
TKTRawProcess >> initialize [
	super initialize.
	masterProcessHolder := TKTRawProcessHolder for: Processor activeProcess
]

{ #category : #testing }
TKTRawProcess >> isTaskItRawProcess [
	^ true
]

{ #category : #initialization }
TKTRawProcess >> isTerminated [
	"Duplicate super method with a tiny difference that avoids an error from looking for #endProcess in TKTRawProcess (see super)."

	self flag: #todo. "Why this happened in Pharo 10 but not in Pharo 9? How to properly fix this?
	See https://github.com/pharo-contributions/taskit/issues/114"

	self isActiveProcess ifTrue: [ ^ false ].
	
	^suspendedContext isNil or: [
		suspendedContext isDead or: [
			Process
				compiledMethodAt: #endProcess
				ifPresent: [ :m | suspendedContext method == m ]
				ifAbsent: [ false ] ]]

]

{ #category : #accessing }
TKTRawProcess >> masterProcessHolder [
	^ masterProcessHolder 
]

{ #category : #accessing }
TKTRawProcess >> masterProcessHolder: aProcessHolder [
	masterProcessHolder := aProcessHolder
]
