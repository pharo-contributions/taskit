"
An archetyped task is like a regular task, but it has an archetype. This archetype is used to select the kind of runner that can respond to this task.
"
Class {
	#name : #TKTArchetypedTask,
	#superclass : #TKTGenericTask,
	#instVars : [
		'archetype',
		'serializer'
	],
	#category : #'TaskItForkIt-Task'
}

{ #category : #'ston persistence' }
TKTArchetypedTask class >> stonOn: aStonWriter [
	
]

{ #category : #accessing }
TKTArchetypedTask >> archetype [
	^ archetype
]

{ #category : #accessing }
TKTArchetypedTask >> archetype: aTKTArchetype [ 
	archetype := aTKTArchetype
]

{ #category : #accessing }
TKTArchetypedTask >> future: executor [
	^ executor futureArchetypedTask: self
]

{ #category : #accessing }
TKTArchetypedTask >> futureTaskExecutionFor: aRunner [
	^ self
		configureTaskExecution: TKTArchetypedTaskExecution new
		with: aRunner
]

{ #category : #accessing }
TKTArchetypedTask >> initialize [
	super initialize.
	self useFuel
]

{ #category : #accessing }
TKTArchetypedTask >> schedule: executor [
	executor scheduleArchetypedTask: self
]

{ #category : #accessing }
TKTArchetypedTask >> scheduleTaskExecutionFor: aRunner [
	^ self
		configureTaskExecution: TKTArchetypedTaskExecution new
		with: aRunner
]

{ #category : #accessing }
TKTArchetypedTask >> serializer [
	^ serializer
]

{ #category : #accessing }
TKTArchetypedTask >> useFuel [
	serializer := #fuel
]

{ #category : #accessing }
TKTArchetypedTask >> useSton [
	serializer := #ston
]

{ #category : #accessing }
TKTArchetypedTask >> useXStoned [
	serializer := #xstoned
]
