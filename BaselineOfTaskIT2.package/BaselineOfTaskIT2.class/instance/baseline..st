baseline
baseline: spec
  <baseline>
	spec
		for: #common
		do: [ 
			spec
				package: #'TaskIT2';
				package: #'TaskIT2-Tests' with: [ spec requires: #('TaskIT2') ];
				package: #'TaskIT2Services' with: [ spec requires: #('TaskIT2') ];
				package: #'TaskIT2Services-Tests' with: [ spec requires: #('TaskIT2Services') ].
				
			spec group: 'minimal' with: #(#TaskIT2) ].