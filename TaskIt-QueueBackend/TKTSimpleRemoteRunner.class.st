Class {
	#name : #TKTSimpleRemoteRunner,
	#superclass : #Object,
	#instVars : [
		'testClassName',
		'timeToRun',
		'timestamp',
		'failures',
		'errors',
		'passed',
		'skipped',
		'failedMessage'
	],
	#category : #'TaskIt-QueueBackend-SimpleTestRunner'
}

{ #category : #convenience }
TKTSimpleRemoteRunner class >> runClass: aTestClass on: runner [

	| testRun |
	
	testRun := self new.
	testRun testClassName: aTestClass name.
	
	^ (MessageSend receiver: testRun selector: #run) asTask future: runner
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> errors [
	^ errors
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> errors: anObject [
	errors := anObject
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> failedMessage [
	^ failedMessage
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> failedMessage: anObject [
	failedMessage := anObject
]

{ #category : #running }
TKTSimpleRemoteRunner >> failedRun: error [

	failedMessage := String
		streamContents: [ :s | 
			s
				nextPutAll: error class name printString;
				nextPutAll: '" message="';
				nextPutAll: (error messageText ifNil: [ error description ]);
				nextPutAll: '">';
				nextPutAll: error signalerContext shortStack ]
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> failures [
	^ failures
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> failures: anObject [
	failures := anObject
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> passed [
	^ passed
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> passed: anObject [
	passed := anObject
]

{ #category : #running }
TKTSimpleRemoteRunner >> run [ 

	| testClass results |

	testClass := testClassName asClass.
	timestamp := DateAndTime now.

	[timeToRun := [results := testClass suite run] timeToRun ] 
		on: Error do: [ :e | self failedRun: e. ^ self ].
		
	passed := results passed collect: [ :e | e printString ].
	skipped := results skipped collect: [ :e | e printString ].
	errors := results errors collect: [ :e | e printString ].
	failures := results failures collect: [ :e | e printString ].
	
	^ self
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> skipped [
	^ skipped
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> skipped: anObject [
	skipped := anObject
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> testClassName [
	^ testClassName
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> testClassName: anObject [
	testClassName := anObject
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> timeToRun [
	^ timeToRun
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> timeToRun: anObject [
	timeToRun := anObject
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> timestamp [
	^ timestamp
]

{ #category : #accessing }
TKTSimpleRemoteRunner >> timestamp: anObject [
	timestamp := anObject
]
