Class {
	#name : #TKTFixedCommandTask,
	#superclass : #TKTTask,
	#instVars : [
		'command',
		'isVerbose'
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

{ #category : #executing }
TKTFixedCommandTask >> isVerbose [
	^ isVerbose ifNil: [ isVerbose := false ]
]

{ #category : #executing }
TKTFixedCommandTask >> redirectStdoutAsResult [
	isVerbose := false
]

{ #category : #executing }
TKTFixedCommandTask >> redirectStdoutToConsole [
	isVerbose := true
]
