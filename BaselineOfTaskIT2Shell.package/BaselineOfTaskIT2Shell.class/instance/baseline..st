baselines
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec
				project: 'OSProcess'
					with: [ spec
						className: #ConfigurationOfOSProcess;
						versionString: #stable;
						repository: 'http://www.squeaksource.com/OSProcess' ];
				project: 'TaskIT2'
					with: [ spec
						className: #ConfigurationOfTaskIT2;
						versionString: #stable;
						repository: 'http://smalltalkhub.com/mc/sbragagnolo/TaskIT2/main/' ].
			spec package: #TaskIT2Shell with: [ spec requires: #('TaskIT2' 'OSProcess') ] ]