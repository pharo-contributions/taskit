Class {
	#name : #BaselineOfTaskItShell,
	#superclass : #BaselineOf,
	#instVars : [
		'repository'
	],
	#category : #BaselineOfTaskItShell
}

{ #category : #'as yet unclassified' }
BaselineOfTaskItShell >> baseline: spec [
	<baseline>
	repository := self packageRepositoryURL .
	spec
		for: #common
		do: [ spec
				baseline: #TaskIt with: [ spec repository: repository ];
				baseline: #OSSubprocess with: [ spec repository: 'github://marianopeck/OSSubprocess:master/repository' ];
				package: #TaskItShell with: [ spec requires: #('TaskIt' 'OSSubprocess') ];
				package: #'TaskItShell-Tests' with: [ spec requires: #('TaskItShell') ].
			spec group: 'minimal' with: #(#TaskItShell) ]

]

{ #category : #'as yet unclassified' }
BaselineOfTaskItShell >> packageRepositoryURL [
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
