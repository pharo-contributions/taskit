Class {
	#name : #TKTUIProcessTaskRunner,
	#superclass : #TKTRunner,
	#category : #'TaskIt-Kernel'
}

{ #category : #scheduling }
TKTUIProcessTaskRunner >> isUIRunner [
	^ true 
]

{ #category : #scheduling }
TKTUIProcessTaskRunner >> scheduleTaskExecution: aTaskExecution [

	UIManager default defer: [ self executeTask: aTaskExecution ]
]

{ #category : #polymorphism }
TKTUIProcessTaskRunner >> start [

]
