Class {
	#name : #BaselineOfForkIt,
	#superclass : #BaselineOf,
	#instVars : [
		'repository'
	],
	#category : #BaselineOfForkIt
}

{ #category : #baselines }
BaselineOfForkIt >> baseline: spec [
	<baseline>
	repository := self packageRepositoryURL.
	spec
		for: #common
		do: [ spec
				baseline: 'ParametrizedTests'
					with: [ spec repository: 'github://tesonep/ParametrizedTests' ];
				baseline: 'Equals'
					with: [ spec repository: 'github://bouraqadi/PharoMisc' ];
				baseline: #TaskItShell with: [ spec repository: repository ];
				baseline: #TaskIt with: [ spec repository: repository ];
				package: 'TaskItForkIt-Tests'
					with: [ spec requires: #(TaskItForkIt) ];
				package: #TaskItForkIt
					with: [ spec requires: #(TaskIt TaskItShell Equals ParametrizedTests) ].
			spec group: 'minimal' with: #(#TaskItForkIt 'TaskItForkIt-Tests') ]
]

{ #category : #baselines }
BaselineOfForkIt >> packageRepositoryURL [
	^ super packageRepositoryURL
		ifEmpty: [ | packageName |
			packageName := self class package name.
			'tonel://'
				,
					(IceRepository registry
						detect: [ :repo | repo workingCopy packageNames includes: packageName ]
						ifFound: [ :repo | repo location pathString , '/' , repo subdirectory ]
						ifNone: [ '' ]) ]
]
