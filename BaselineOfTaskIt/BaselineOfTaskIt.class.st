Class {
	#name : #BaselineOfTaskIt,
	#superclass : #BaselineOf,
	#category : #BaselineOfTaskIt
}

{ #category : #catalog }
BaselineOfTaskIt class >> catalogContactInfo [
	^ 'santiagobragagnolo@gmail.com'
]

{ #category : #catalog }
BaselineOfTaskIt class >> catalogDescription [
	^ 'Task & Jobs oriented multiprocessing framework. Check for nicely showed documentation at https://github.com/pharo-contributions/taskit/ :)'
]

{ #category : #catalog }
BaselineOfTaskIt class >> catalogKeywords [
	^ {'multiprocessing'. 'futures'. 'tasks'. 'services'. }
]

{ #category : #baseline }
BaselineOfTaskIt >> baseline: spec [
	<baseline>
	spec for: #'pharo8.x' do: [ self baselineForPharo8: spec ].
	spec for: #'pharo9.x' do: [ self baselineForPharo9: spec ].
]

{ #category : #baseline }
BaselineOfTaskIt >> baselineForCommon: spec [

	spec
		package: #'TaskIt-Tests' with: [ spec requires: #('TaskIt') ];
		package: #TaskItRetry with: [ spec requires: #('TaskIt') ];
		package: #'TaskItRetry-Tests' with: [ spec requires: #('TaskItRetry') ];
		package: #TaskItProcesses with: [ spec requires: #('TaskIt') ];
		package: #'TaskItProcesses-Tests' with: [ spec requires: #('TaskItProcesses') ];
		package: #TaskItBrowser with: [ spec requires: #('TaskItProcesses') ];
		package: #TaskItDebugger with: [ spec requires: #('TaskItProcesses') ];
		package: #'TaskItDebugger-Tests' with: [ spec requires: #('TaskItDebugger') ].

	spec
		group: 'core' with: #('TaskIt');
		group: 'coreTests' with: #('TaskIt' 'TaskIt-Tests');
		group: 'default' with: #(
			'core' 
			'TaskItProcesses' 
			'TaskItRetry' 
			'TaskItDebugger' 
			'TaskIt-Tests' 
			'TaskItRetry-Tests' 
			'TaskItProcesses-Tests' 
			'TaskItDebugger-Tests');
		group: 'debug' with: #('core' 'TaskItDebugger');
		group: 'tests' with: #(
			'default' 
			'TaskIt-Tests' 
			'TaskItRetry-Tests' 
			'TaskItProcesses-Tests' 
			'TaskItDebugger-Tests');
		group: 'development' with: #('default' 'debug' 'tests')
]

{ #category : #baseline }
BaselineOfTaskIt >> baselineForPharo8: spec [

	spec package: #TaskIt.
	self baselineForCommon: spec
]

{ #category : #baseline }
BaselineOfTaskIt >> baselineForPharo9: spec [

	spec package: #TaskIt.
	self baselineForCommon: spec.

	"Override group without the TaskItDebugger package (and tests)."
	spec group: 'default' overrides: #(
		'core' 
		'TaskItProcesses' 
		'TaskItRetry' 
		'TaskIt-Tests' 
		'TaskItRetry-Tests' 
		'TaskItProcesses-Tests').

]
