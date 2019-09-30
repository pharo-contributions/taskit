"
I am a process provider that creates Pharo processes using the TKTProcess implementation 
"
Class {
	#name : #TKTTaskItProcessProvider,
	#superclass : #TKTProcessProvider,
	#category : #TaskItProcesses
}

{ #category : #'instance-creation' }
TKTTaskItProcessProvider >> createProcessDoing: aValuable [
	^ self createProcessDoing: aValuable named: nil
]

{ #category : #'instance-creation' }
TKTTaskItProcessProvider >> createProcessDoing: aValuable named: aName [

	^ (TKTProcess send: #value to: aValuable)
		annotate: #task with: aValuable;
		name: aName;
		run
]

{ #category : #configuration }
TKTTaskItProcessProvider >> isDebuggingCompatible [
	^ true
]
