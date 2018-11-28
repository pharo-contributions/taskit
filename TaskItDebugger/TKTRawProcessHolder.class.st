"
I am a helper that knows how to store a reference to another process.

I store a reference to a process and a list of TKTContextHolder instances that hold copies of the referenced process' contexts. I know how to create a stack for the debugger recursively and I provide convenience methods to traverse the list of context holders.
"
Class {
	#name : #TKTRawProcessHolder,
	#superclass : #Object,
	#instVars : [
		'process',
		'contextHolders'
	],
	#category : 'TaskItDebugger'
}

{ #category : #'instance creation' }
TKTRawProcessHolder class >> for: aProcess [
	^ self new
		initializeWithProcess: aProcess;
		yourself
]

{ #category : #query }
TKTRawProcessHolder >> findContextHolderSuchThat: aBlock [
	^ contextHolders
		detect: aBlock
		ifNone: [
			self process isTaskItRawProcess
				ifTrue: [ self process masterProcessHolder findContextHolderSuchThat: aBlock ]
				ifFalse: [ nil ] ]
]

{ #category : #query }
TKTRawProcessHolder >> findNextContextHolder: aContextHolder suchThat: aBlock [
	aContextHolder index >= contextHolders size ifTrue: [ ^ nil ].
	
	contextHolders
		from: aContextHolder index + 1
		to: contextHolders size
		do: [ :contextHolder |
			(aBlock value: contextHolder) ifTrue: [ ^ contextHolder ] ].
		
	^ nil
]

{ #category : #testing }
TKTRawProcessHolder >> hasContext: aContext [
	^ (self holderForContext: aContext) notNil
]

{ #category : #query }
TKTRawProcessHolder >> holderForContext: aContext [
	^ self findContextHolderSuchThat: [ :contextHolder |
		contextHolder originalContext == aContext or: [
			contextHolder copyContext == aContext ] ]
]

{ #category : #initialization }
TKTRawProcessHolder >> initializeWithProcess: aProcess [
	| stackCopy previousHolder |
	process := WeakArray with: aProcess.
	stackCopy := thisContext copyStack stack.
	contextHolders := thisContext stack
		withIndexCollect: [ :context :index | 
			TKTContextHolder
				forProcess: process
				context: context
				andCopy: (stackCopy at: index)
				withIndex: index ].
	previousHolder := nil.
	contextHolders reverse
		do: [ :contextHolder | 
			contextHolder next: previousHolder.
			previousHolder := contextHolder ]
]

{ #category : #accessing }
TKTRawProcessHolder >> process [
	^ process at:1
]

{ #category : #query }
TKTRawProcessHolder >> stack [
	^ contextHolders
		ifEmpty: [ #() ]
		ifNotEmpty: [ self stackStartingAt: contextHolders first ]
]

{ #category : #query }
TKTRawProcessHolder >> stackStartingAt: aContextHolder [
	| stack isSuspended |
	(aContextHolder isNil or: [
		aContextHolder index >= contextHolders size ]) ifTrue: [ ^ #() ].

	"Include all live contexts (only when the process has been suspended)
	so that actions on live contexts can be performed on that context
	immediately without the need to lookup the equivalent context."
	isSuspended := self process isSuspended.
	stack := OrderedCollection new.
	contextHolders
		from: aContextHolder index
		to: contextHolders size
		do: [ :contextHolder |
			stack add: ((isSuspended not or: [
				contextHolder isDead ])
					ifTrue: [ contextHolder copyContext ]
					ifFalse: [ contextHolder originalContext ]) ].

	^ self process isTaskItRawProcess
		ifFalse: [ stack ]
		ifTrue: [ stack, self process masterProcessHolder stack ]
]
