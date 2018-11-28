"
This process model represents the TKTProcess. For allowing to watch the information of the processes it picks it up, to avoid garbage collection. 
`However, once the table is closed, all will be garbage collected. 
"
Class {
	#name : #TKTProcessModel,
	#superclass : #Object,
	#instVars : [
		'process',
		'actionIcon',
		'receiver',
		'selector',
		'arguments',
		'job',
		'task'
	],
	#category : 'TaskItBrowser-Widget'
}

{ #category : #'as yet unclassified' }
TKTProcessModel class >> on: aTktProcess [
	^ self new
		process: aTktProcess;
		yourself
]

{ #category : #accessing }
TKTProcessModel >> actionOn: aBrowser [
	^ actionIcon ifNil: [ actionIcon := self createActionIconOn: aBrowser ]
]

{ #category : #accessing }
TKTProcessModel >> arguments [
	^ arguments
]

{ #category : #factory }
TKTProcessModel >> createActionIconOn: aBrowser [
	^ Smalltalk ui icons iconNamed: #flagIcon
]

{ #category : #notices }
TKTProcessModel >> hasBeenCancelled [

]

{ #category : #notices }
TKTProcessModel >> hasBeenResumed [
]

{ #category : #notices }
TKTProcessModel >> hasBeenSuspended [
]

{ #category : #notices }
TKTProcessModel >> hasFinished [
]

{ #category : #accessing }
TKTProcessModel >> indexString [
	^ '{name}:{selector}:{receiver}:{state}'
		format:
			{(#name -> self name ).
			(#selector -> self selector asString).
			(#receiver -> self receiver asString).
			(#state -> self state asString)} asDictionary
]

{ #category : #accessing }
TKTProcessModel >> messageSend [
	^ process messageSend
]

{ #category : #accessing }
TKTProcessModel >> model [
	^ process
]

{ #category : #accessing }
TKTProcessModel >> name [
	^ process name
]

{ #category : #accessing }
TKTProcessModel >> process: aTktProcess [
	| messageSend |
	process := aTktProcess.
	task := aTktProcess annotation: #task.
	messageSend := aTktProcess messageSend.
	messageSend
		ifNotNil: [ :ms | 
			receiver := ms receiver.
			selector := ms selector.
			arguments := ms arguments ].
]

{ #category : #accessing }
TKTProcessModel >> receiver [
	^ receiver
]

{ #category : #accessing }
TKTProcessModel >> selector [
	^ selector
]

{ #category : #accessing }
TKTProcessModel >> state [
	^ process
		ifNotNil: [ :p | 
			p
				ifRunning: [ 
					p isSuspended
						ifTrue: [ 'Suspended' ]
						ifFalse: [ 'Running' ] ]
				ifNotRunning: 'NotRunning' ]
]

{ #category : #accessing }
TKTProcessModel >> task [
	^ task
		ifNotNil: [ task ]
		ifNil: [ 'NonTaskRelated' ]
]
