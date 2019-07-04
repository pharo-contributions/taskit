"
Watchdog watches the common queue worker pool to ensure the good working of this pool
"
Class {
	#name : #TKTWatchDog,
	#superclass : #TKTService,
	#instVars : [
		'values'
	],
	#classInstVars : [
		'onDuty'
	],
	#category : #'TaskIt-Worker'
}

{ #category : #accessing }
TKTWatchDog class >> onDuty [
	^ onDuty ifNil: [ onDuty := self new ]
]

{ #category : #initialization }
TKTWatchDog >> delay [
	^ 10 seconds
]

{ #category : #initialization }
TKTWatchDog >> ensureIsAwake [
	self isRunning
		ifFalse: [ self restart ]
]

{ #category : #initialization }
TKTWatchDog >> ensureIsWatching: aValue [
	(values includes: aValue)
		ifFalse: [ self watch: aValue ].
	self ensureIsAwake
]

{ #category : #initialization }
TKTWatchDog >> initialize [
	super initialize.
	values := WeakSet new
]

{ #category : #initialization }
TKTWatchDog >> name [
	^ 'WatchDog - Garden size: ' , values size asString
]

{ #category : #initialization }
TKTWatchDog >> stepService [
	self watchedValues
		ifEmpty: [ self stop ]
		ifNotEmpty: [ :values | 
			values do: [ :v | self watchDog: v ].
			self delay wait ]
]

{ #category : #initialization }
TKTWatchDog >> stopWatching: aValue [
	values remove: aValue ifAbsent: [  ]
]

{ #category : #initialization }
TKTWatchDog >> watch: aValue [
	values add: aValue
]

{ #category : #initialization }
TKTWatchDog >> watchDog: aParameterPool [
	[ aParameterPool ensureIsWorking ]
		on: Error
		do: [ :err | 
			self log: err printString.
			self
				log:
					'Watch dog is not watching anymore the value: '
						,
							(values remove: aParameterPool ifAbsent: [ aParameterPool ])
								printString ]
]

{ #category : #initialization }
TKTWatchDog >> watchedValues [
	
	^  values
]
