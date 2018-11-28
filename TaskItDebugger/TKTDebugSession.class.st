"
I implement the debugging logic for the ThreadDebugger.

I override many of the action methods of DebugSession in order to deal with the virtual call stack correctly. I also hold a reference to the process holder that holds the process which caused the debugger to be opened; I need this reference to ensure continued access to the complete call stack, regardless of the currently active or focused context / process.
"
Class {
	#name : #TKTDebugSession,
	#superclass : #DebugSession,
	#instVars : [
		'exceptionProcessHolder'
	],
	#category : 'TaskItDebugger'
}

{ #category : #testing }
TKTDebugSession >> canStepFrom: aContext [
	| holder |
	holder := exceptionProcessHolder holderForContext: aContext.
	^ holder
		ifNotNil: [ holder canStep ]
		ifNil: [ (self isContextPostMortem: aContext) not ]
]

{ #category : #private }
TKTDebugSession >> filteredCombinedStack [
	^ self filteredSlaveStack
		addAll: self filteredMasterStack;
		yourself
]

{ #category : #private }
TKTDebugSession >> filteredMasterStack [
	| masterHolder entryPointHolder |
	masterHolder := interruptedProcess masterProcessHolder.
	entryPointHolder := masterHolder findContextHolderSuchThat: [ :contextHolder |
		contextHolder originalContext selector = #future and: [
			contextHolder originalContext receiver isKindOf: TKTTask ] ].
	entryPointHolder := (entryPointHolder notNil and: [
		entryPointHolder next originalContext receiver class = BlockClosure and: [
			entryPointHolder next originalContext selector = #future ] ])
				ifTrue: [ entryPointHolder next ]
				ifFalse: [ entryPointHolder ].
	^ entryPointHolder
		ifNil: [ masterHolder stack ]
		ifNotNil: [ masterHolder stackStartingAt: entryPointHolder next ]
]

{ #category : #private }
TKTDebugSession >> filteredSlaveStack [
	"skip process creation context"
	| firstInterestingContext |
	firstInterestingContext := interruptedContext stack
		detect: [ :ctxt |
			ctxt notNil and: [
				(ctxt receiver isKindOf: TKTTask) and: [
					ctxt selector = #value ] ] ]
		ifNone: [  ^ interruptedContext stack allButLast ].
		
	^ interruptedContext stack copyUpTo: firstInterestingContext
]

{ #category : #testing }
TKTDebugSession >> isContextPostMortem: selectedContext [
	^ selectedContext isDead
]

{ #category : #initialization }
TKTDebugSession >> process: aProcess context: aContext [
 	super
		process: aProcess
		context: aContext.
	
	exceptionProcessHolder := TKTRawProcessHolder for: aProcess
	

]

{ #category : #'debugging actions' }
TKTDebugSession >> restart: aContext [
	"Proceed from the initial state of selectedContext." 
	"Closing now depends on a setting (RestartAlsoProceeds class variable) --> not supported in this version"

	(self canStepFrom: aContext) ifFalse: [^ self].
	
	super restart: aContext
	
]

{ #category : #'debugging actions' }
TKTDebugSession >> returnValue: anObject from: aContext [
	"Force a return of a given value to the previous context!"
	(self canStepFrom: aContext) ifFalse: [^ self].

	super
		returnValue: anObject
		from: aContext
]

{ #category : #accessing }
TKTDebugSession >> stack [
	^ interruptedProcess isTaskItRawProcess
		ifTrue: [ self filteredCombinedStack ]
		ifFalse: [ super stack ]
]

{ #category : #'debugging actions' }
TKTDebugSession >> stepInto: aContext [
	"Send the selected message in selectedContext, and take control in 
	the method invoked to allow further step or send."

	| holder |
	(self canStepFrom: aContext) ifFalse: [ ^ self ].
	
	aContext willSend ifFalse: [ ^ self stepOver: aContext ].
	
	holder := exceptionProcessHolder holderForContext: aContext.
	holder ifNil: [ ^ super stepInto: aContext ].
	
	holder step.
	
	self updateContextTo: (self stepToFirstInterestingBytecodeIn: holder process).
	
	self triggerEvent: #stepInto
]

{ #category : #'debugging actions' }
TKTDebugSession >> stepOver: aContext [
	"Send the selected message in selectedContext, and regain control 
	after the invoked method returns."
	
	| newContext holder |
	(self canStepFrom: aContext) ifFalse: [ ^ self ].

	holder := exceptionProcessHolder holderForContext: aContext.
	holder ifNil: [ ^ super stepOver: aContext ].
	
	newContext := holder completeStep.

	self updateContextTo:  
		(newContext == aContext
			ifTrue: [ self stepToFirstInterestingBytecodeIn: holder process ]
			ifFalse: [ newContext ]).

	self triggerEvent: #stepOver
]

{ #category : #'debugging actions' }
TKTDebugSession >> stepThrough: aContext [
	"Send messages until you return to selectedContext.
	 Used to step into a block in the method."
	| holder |
	(self canStepFrom: aContext) ifFalse: [ ^ self ].

	aContext willSend ifFalse: [ ^ self stepOver: aContext ].

	holder := exceptionProcessHolder holderForContext: aContext.
	holder ifNil: [ ^ super stepThrough: aContext ].
	
	holder stepToHome.
	self updateContextTo: (self stepToFirstInterestingBytecodeIn: holder process).
			
	self triggerEvent: #stepThrough 
]

{ #category : #evaluating }
TKTDebugSession >> unwindAndRestartToContext: aContext [
	|ctx holder |
	holder := exceptionProcessHolder holderForContext: aContext.
	holder ifNil: [ ^ super unwindAndRestartToContext: aContext ].
	
	ctx := holder popTo.
	ctx == aContext ifTrue: [ 
		"Only restart the process if the stack was unwind"
		holder process restartTop.
		self stepToFirstInterestingBytecodeIn: holder process ].
	
	self updateContextTo:  aContext
]
