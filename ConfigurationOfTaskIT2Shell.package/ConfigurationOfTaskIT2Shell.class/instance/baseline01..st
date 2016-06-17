baselines
baseline01: spec
	<version: '0.1-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/sbragagnolo/TaskIT2/main/'.
		spec 
			project: 'OSProcess' with: [
				spec
					className: #ConfigurationOfOSProcess;
					versionString: #'stable';
					repository: 'http://www.squeaksource.com/OSProcess' ];
			project: 'TaskIT2' with: [
				spec
					className: #ConfigurationOfTaskIT2;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/sbragagnolo/TaskIT2/main/' ].
		spec package: #TaskIT2Shell with: [
				spec requires: #('TaskIT2' 'OSProcess' ). ]. ].
