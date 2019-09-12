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
	repository := self packageRepositoryURL.
	spec
		for: #common
		do: [ spec
				baseline: #TaskIt
					with: [ spec repository: 'github://sbragagnolo/taskit' ];
				baseline: #OSSubprocess
					with: [ spec
						repository: 'github://marianopeck/OSSubprocess:master/repository' ];
				package: #TaskItShell
					with: [ spec requires: #('TaskIt' 'OSSubprocess') ];
				package: #'TaskItShell-Tests'
					with: [ spec requires: #('TaskItShell') ].
			spec group: 'minimal' with: #(#TaskItShell) ]
]

{ #category : #'as yet unclassified' }
BaselineOfTaskItShell >> packageRepository [

	" Tries to determine a repository from which the baseline is being loaded. Useful for 
	refering other baselines in the same repository. "
	
	^ (self class package mcWorkingCopy repositoryGroup repositories reject: [:each | each = MCCacheRepository uniqueInstance]) 
		ifNotEmpty: [ :repositories | repositories anyOne ]
		ifEmpty: [ nil ]


	
]

{ #category : #'as yet unclassified' }
BaselineOfTaskItShell >> packageRepositoryURL [
	| packageName |
	^ self packageRepository
		ifNotNil: [ :aRepository | aRepository description ]
		ifNil: [ packageName := self class package name.
			'tonel://'
				,
					(IceRepository registry
						detect: [ :repo | repo workingCopy packageNames includes: packageName ]
						ifFound: [ :repo | repo location pathString ]
						ifNone: [ '' ]) ]
]
