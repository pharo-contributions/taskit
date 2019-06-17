Class {
	#name : #BaselineOfForkIt,
	#superclass : #BaselineOf,
	#category : #BaselineOfForkIt
}

{ #category : #baselines }
BaselineOfForkIt >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: #TaskItShell
					with: [ spec repository: 'github://sbragagnolo/taskit' ];
				package: #TaskItForkIt with: [ spec requires: #(TaskItShell) ].
			spec group: 'minimal' with: #(#TaskItForkIt) ]
]
