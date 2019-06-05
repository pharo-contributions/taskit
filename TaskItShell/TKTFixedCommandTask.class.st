Class {
	#name : #TKTFixedCommandTask,
	#superclass : #TKTTask,
	#instVars : [
		'command'
	],
	#category : #TaskItShell
}

{ #category : #executing }
TKTFixedCommandTask >> command [
	^ command ifNil: [ self error: 'Not command setted! ' ]
]

{ #category : #executing }
TKTFixedCommandTask >> command: aCommand [ 
	^ command := aCommand
]

{ #category : #executing }
TKTFixedCommandTask >> futureTaskExecutionFor: aRunner [
	| execution |
	execution := TKTOSTaskExecution new.
	execution runner: aRunner.
	execution task: self.
	^ execution
]
