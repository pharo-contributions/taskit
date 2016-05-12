sugar - examples - builder - service
exampleServiceTaskInANewProcessSugar
	<example>
	| jobExecution |
	jobExecution := (self -> #spinOnce) tkt
		loopingService;
		onServiceFinalization: [ Transcript logCr: 'Service has finished' ]
			onFailure: [ :err | self inform: err messageText ];
		inALocalProcess;
		start.
	1 second wait.
	jobExecution stop