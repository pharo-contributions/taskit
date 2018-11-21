"
I am a helper that knows how to interact with context copies.

I hold references to a context and its copy, know the position of the referenced context in the call stack and know which context holder is next in the virtual call stack. I also store a reference to the process to which the referenced context belongs, as the debugger only knows about single threaded call stacks but we may be dealing with multiple processes.
"
Class {
	#name : #TKTContextHolder,
	#superclass : #Object,
	#instVars : [
		'original',
		'copy',
		'index',
		'next',
		'process'
	],
	#category : 'TaskItDebugger'
}

{ #category : #'instance creation' }
TKTContextHolder class >> forProcess: aProcess context: originalContext andCopy: copyContext withIndex: anInteger [
	^ self new
		initializeWithProcess: aProcess
			context: originalContext
			andCopy: copyContext
			withIndex: anInteger;
		yourself
]

{ #category : #testing }
TKTContextHolder >> canStep [
	^ self isDead not and: [
		self process suspendedContext notNil and: [
			self hasNext and: [
				self next isDead not ] ] ]
]

{ #category : #'changing suspended state' }
TKTContextHolder >> completeStep [
	^ self process completeStep: self originalContext
]

{ #category : #accessing }
TKTContextHolder >> copyContext [
	^ copy at:1 
]

{ #category : #testing }
TKTContextHolder >> hasNext [
	^ self next notNil
]

{ #category : #accessing }
TKTContextHolder >> index [
	^ index
]

{ #category : #initialization }
TKTContextHolder >> initializeWithProcess: aProcess context: originalContext andCopy: copyContext withIndex: anInteger [
	process := aProcess.
	original := WeakArray with: originalContext.
	copy := WeakArray with: copyContext.
	index := anInteger
]

{ #category : #testing }
TKTContextHolder >> isDead [
	^ self originalContext isDead
]

{ #category : #accessing }
TKTContextHolder >> next [
	^ next
]

{ #category : #accessing }
TKTContextHolder >> next: aContextHolder [
	next := aContextHolder
]

{ #category : #accessing }
TKTContextHolder >> originalContext [
	^ original at: 1
]

{ #category : #'changing suspended state' }
TKTContextHolder >> popTo [
	^ self process popTo: self originalContext
]

{ #category : #accessing }
TKTContextHolder >> process [
	^ process at: 1
]

{ #category : #'changing suspended state' }
TKTContextHolder >> step [
	^ self process step: self originalContext
]

{ #category : #'changing suspended state' }
TKTContextHolder >> stepToHome [
	^ self process stepToHome: self originalContext
]
