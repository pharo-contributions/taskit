"
An archetyped task is like a regular task, but it has an archetype. This archetype is used to select the kind of runner that can respond to this task.
"
Class {
	#name : #TKTArchetypedTask,
	#superclass : #TKTGenericTask,
	#instVars : [
		'archetype'
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
TKTArchetypedTask >> futureTaskExecutionFor: aRunner [
	aRunner supportsArchetyping
		ifFalse: [ ^ self error: ' The current runner do no support archetyping. ' ].
	^ self
		configureTaskExecution: TKTArchetypedTaskExecution new
		with: aRunner
]

{ #category : #accessing }
TKTArchetypedTask >> scheduleTaskExecutionFor: aRunner [
	aRunner supportsArchetyping
		ifFalse: [ ^ self error: ' The current runner do no support archetyping. ' ].
	^ self
		configureTaskExecution: TKTArchetypedTaskExecution new
		with: aRunner
]
