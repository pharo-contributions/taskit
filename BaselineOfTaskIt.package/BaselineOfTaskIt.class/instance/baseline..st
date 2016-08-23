baseline
baseline: spec
  <baseline>
	spec
		for: #common
		do: [ 
			spec
				package: #'TaskIt';
				package: #'TaskIt-Tests' with: [ spec requires: #('TaskIt') ];
				package: #'TaskItServices' with: [ spec requires: #('TaskIt') ];
				package: #'TaskItServices-Tests' with: [ spec requires: #('TaskItServices') ].
				
			spec group: 'minimal' with: #(#TaskIt) ].