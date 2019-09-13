Class {
	#name : #TKTHeartbeatEvent,
	#superclass : #TKTAbstractEvent,
	#instVars : [
		'time',
		'ip',
		'pid',
		'hostName'
	],
	#category : #'TaskIt-QueueBackend'
}

{ #category : #accessing }
TKTHeartbeatEvent >> hostName [
	^ hostName
]

{ #category : #accessing }
TKTHeartbeatEvent >> hostName: anObject [
	hostName := anObject
]

{ #category : #accessing }
TKTHeartbeatEvent >> initialize [

	super initialize.
	ip := NetNameResolver localHostAddress.
	hostName := 	NetNameResolver localHostAddress.
	time := Time new.
	pid := OSEnvironment current getPid.
	
]

{ #category : #accessing }
TKTHeartbeatEvent >> ip [
	^ ip
]

{ #category : #accessing }
TKTHeartbeatEvent >> ip: anObject [
	ip := anObject
]

{ #category : #accessing }
TKTHeartbeatEvent >> pid [
	^ pid
]

{ #category : #accessing }
TKTHeartbeatEvent >> pid: anObject [
	pid := anObject
]

{ #category : #accessing }
TKTHeartbeatEvent >> time [
	^ time
]

{ #category : #accessing }
TKTHeartbeatEvent >> time: anObject [
	time := anObject
]
