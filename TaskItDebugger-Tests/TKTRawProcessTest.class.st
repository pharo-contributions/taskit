Class {
	#name : #TKTRawProcessTest,
	#superclass : #TKTTestCase,
	#category : 'TaskItDebugger-Tests'
}

{ #category : #helpers }
TKTRawProcessTest >> newRawProcess [
	| dummyObject messageSend process raw |
	dummyObject := Dictionary new.
	messageSend := MessageSend
		receiver: dummyObject
		selector: #at:put: 
		arguments: {'key'.	'value'}.
	process := TKTProcess forMessageSend: messageSend.
	TKTConfiguration
		process: TKTRawProcess
		during: [ raw := process privateCreatePharoProcess
				resume;
				yourself ].
	^ raw
]

{ #category : #tests }
TKTRawProcessTest >> testIsTaskItRawProcess [
	| rawProcess |
	rawProcess := self newRawProcess.
	
	self assert: rawProcess isTaskItRawProcess
]

{ #category : #tests }
TKTRawProcessTest >> testMasterProcessHolder [
	| process process2 |
	process := self newRawProcess.
	self assert: process masterProcessHolder notNil.
	self assert: process masterProcessHolder process == Processor activeProcess.
	
	process2 := self newRawProcess.
	process masterProcessHolder: (TKTRawProcessHolder for: process2).
	
	self assert: process masterProcessHolder process == process2.
	self assert: process2 masterProcessHolder process == Processor activeProcess
]
