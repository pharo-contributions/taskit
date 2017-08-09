as yet unclassified
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: #TaskIt with: [ spec repository: 'github://sbragagnolo/taskit:dev-0.3' ];
				baseline: #OSSubprocess with: [ spec repository: 'github://marianopeck/OSSubprocess:master/repository' ];
				package: #TaskItShell with: [ spec requires: #('TaskIt' 'OSSubprocess') ];
				package: #'TaskItShell-Tests' with: [ spec requires: #('TaskItShell') ].
			spec group: 'minimal' with: #(#TaskItShell) ]