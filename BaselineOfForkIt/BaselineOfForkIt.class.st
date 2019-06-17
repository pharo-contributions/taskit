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
				baseline: 'Equals'
					with: [ spec repository: 'github://bouraqadi/PharoMisc' ];
				baseline: #TaskItShell
					with: [ spec repository: 'github://sbragagnolo/taskit' ];
				package: #TaskItForkIt
					with: [ spec requires: #(TaskItShell 'Equals') ].
			spec group: 'minimal' with: #(#TaskItForkIt) ]
]
