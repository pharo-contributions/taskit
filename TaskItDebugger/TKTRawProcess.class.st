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
	#category : 'TaskItDebugger'
}

{ #category : #initialization }
TKTRawProcess >> initialize [
	super initialize.
	masterProcessHolder := TKTRawProcessHolder for: Processor activeProcess
]

{ #category : #testing }
TKTRawProcess >> isTaskItRawProcess [
	^ true
]

{ #category : #accessing }
TKTRawProcess >> masterProcessHolder [
	^ masterProcessHolder 
]

{ #category : #accessing }
TKTRawProcess >> masterProcessHolder: aProcessHolder [
	masterProcessHolder := aProcessHolder
]
