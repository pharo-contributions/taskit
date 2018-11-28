"
Test
"
Class {
	#name : #TKTActItActorSMailBox,
	#superclass : #TestCase,
	#instVars : [
		'actor'
	],
	#category : 'ActIt-Tests'
}

{ #category : #running }
TKTActItActorSMailBox >> setUp [
	super setUp.
	actor := TKTActorBehaviourTest new actor.
]

{ #category : #running }
TKTActItActorSMailBox >> testActorMessageSendReceiverIsSetted [
	actor send: (Message selector: #yourself arguments: {}).
	self assert: (actor mailbox next isKindOf: TKTFutureExecution)
]

{ #category : #running }
TKTActItActorSMailBox >> testActorMessageSendSchedulesIntoMailBox [
	actor send: (Message selector: #yourself arguments: {}).
	self assert: actor mailbox size equals: 1
]

{ #category : #running }
TKTActItActorSMailBox >> testActorMessageSendSchedulesReturnsAFuture [
	| future |
	future := actor send: (Message selector: #yourself arguments: {}).
	self assert: (future isKindOf: TKTFuture)
]
