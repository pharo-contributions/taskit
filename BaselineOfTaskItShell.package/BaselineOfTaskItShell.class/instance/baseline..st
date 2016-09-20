as yet unclassified
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: #TaskIt with: [ spec repository: 'filetree://.' ];
				baseline: #OSSubprocess with: [ spec repository: 'github://marianopeck/OSSubprocess:master/repository' ];
				package: #TaskItShell with: [ spec requires: #('TaskIt' 'OSSubprocess') ];
				package: #'TaskItShell-Tests' with: [ spec requires: #('TaskItShell') ].
			spec group: 'minimal' with: #(#TaskItShell) ]