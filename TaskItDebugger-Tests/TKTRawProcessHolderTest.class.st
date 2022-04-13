Class {
	#name : #TKTRawProcessHolderTest,
	#superclass : #TKTTestCase,
	#category : #'TaskItDebugger-Tests'
}

{ #category : #helpers }
TKTRawProcessHolderTest >> expectedFailures [

	^ super expectedFailures , #( testStackContainsContextsOfMaster testStackStartingAt )
]

{ #category : #helpers }
TKTRawProcessHolderTest >> newRawProcess [
	| dummyObject messageSend process raw |
	dummyObject := Dictionary new.
	messageSend := MessageSend receiver: dummyObject selector: #at:put: arguments: {'key' . 'value'}.
	process := TKTProcess forMessageSend: messageSend.
	TKTConfiguration
		process: TKTRawProcess
		during: [ raw := process privateCreatePharoProcess
				resume;
				yourself ].
	^ raw
]

{ #category : #tests }
TKTRawProcessHolderTest >> testFindNextContextHolderSuchThat [
	| process contextHolder |
	process := self newRawProcess.
	
	contextHolder := process masterProcessHolder findContextHolderSuchThat: [ :context | true ].
	self assert: contextHolder index = 1.
	
	contextHolder := process masterProcessHolder
		findNextContextHolder: contextHolder
		suchThat: [ :context | context index > 5 ].
	self assert: contextHolder index = 6.
	
	contextHolder := process masterProcessHolder
		findNextContextHolder: contextHolder
		suchThat: [ :context | context index > 5 ].
	self assert: contextHolder index = 7
]

{ #category : #tests }
TKTRawProcessHolderTest >> testHasContext [
	| process |
	process := self newRawProcess.
	
	self assert: (process masterProcessHolder hasContext: thisContext).
	self deny: (process masterProcessHolder hasContext: nil)
]

{ #category : #tests }
TKTRawProcessHolderTest >> testHolderForContext [
	| process contextHolder |
	process := self newRawProcess.
	
	contextHolder := process masterProcessHolder holderForContext: thisContext.
	self assert: contextHolder originalContext == thisContext
]

{ #category : #tests }
TKTRawProcessHolderTest >> testStackContainsContextsOfMaster [
	| process |
	process := self newRawProcess.
	thisContext stack
		do: [ :context | self assert: (process masterProcessHolder stack identityIncludes: context) ]
]

{ #category : #tests }
TKTRawProcessHolderTest >> testStackContainsEvenReturnedFromContexts [
	"The stack must contain all contexts, even those already returned from"
	| process |
	process := self newRawProcess.
	
	self assert: (process masterProcessHolder stack contains: [ :context |
		context selector = #newRawProcess and: [
			context methodClass = self class ] ])
]

{ #category : #tests }
TKTRawProcessHolderTest >> testStackContainsOnlyLiveContexts [
	"Any dead contexts will be replaced by copies, the copies are still live"
	| process |
	process := self newRawProcess.
	
	self assert: (process masterProcessHolder stack noneSatisfy: [ :context |
		context isDead ])
]

{ #category : #tests }
TKTRawProcessHolderTest >> testStackStartingAt [
	| process here contextHolder stack |
	process := self newRawProcess.
	
	here := thisContext.
	contextHolder := process masterProcessHolder findContextHolderSuchThat: [ :holder |
		holder originalContext == here ].
	stack := process masterProcessHolder stackStartingAt: contextHolder.
	
	self assert: stack first == here
]
