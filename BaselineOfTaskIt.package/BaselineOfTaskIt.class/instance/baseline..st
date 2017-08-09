baseline
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec
				package: #TaskIt;
				package: #'TaskIt-Tests' with: [ spec requires: #('TaskIt') ];
				
				package: #TaskItRetry with: [ spec requires: #('TaskIt') ];
				package: #'TaskItRetry-Tests' with: [ spec requires: #('TaskItRetry') ];
				
				package: #TaskItServices with: [ spec requires: #('TaskIt') ];
				package: #'TaskItServices-Tests' with: [ spec requires: #('TaskItServices') ];
				
				package: #TaskItProcesses with: [ spec requires: #('TaskIt') ];
				package: #'TaskItProcesses-Tests' with: [ spec requires: #('TaskItProcesses') ];
				
				package: #TaskItBrowser with: [ spec requires: #('TaskItProcesses') ];
				
				package: #TaskItDebugger with: [ spec requires: #('TaskItProcesses') ];
				package: #'TaskItDebugger-Tests' with: [ spec requires: #('TaskItDebugger') ].
				
			spec
				group: 'minimal' with: #('TaskIt');
				group: 'default' with: #('minimal' 'TaskItProcesses' 'TaskItRetry' 'TaskItServices');
				group: 'debug' with: #('minimal' 'TaskItDebugger');
				group: 'tests' with: #('default' 'TaskIt-Tests' 'TaskItRetry-Tests' 'TaskItServices-Tests'
					'TaskItProcesses-Tests' 'TaskItDebugger-Tests');
				group: 'development' with: #('default' 'debug' 'tests') ]