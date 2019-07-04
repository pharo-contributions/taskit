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
	self logCr: 'RemoteIs: ' , Iceberg remoteTypeSelector.
	Iceberg remoteTypeSelector: #httpsUrl.
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
BaselineOfForkIt >> packageRepository [

	" Tries to determine a repository from which the baseline is being loaded. Useful for 
	refering other baselines in the same repository. "
	
	^ (self class package mcWorkingCopy repositoryGroup repositories reject: [:each | each = MCCacheRepository uniqueInstance]) 
		ifNotEmpty: [ :repositories | repositories anyOne ]
		ifEmpty: [ nil ]


	
]

{ #category : #baselines }
BaselineOfForkIt >> packageRepositoryURL [
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
