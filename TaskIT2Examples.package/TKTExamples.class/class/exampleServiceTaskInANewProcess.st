examples - builder - service
exampleServiceTaskInANewProcess
	<example>
	| builder jobExecution |
	builder := TKTBuilder new.
	jobExecution := builder
		loopingService;
		onServiceFinalization: [ Transcript logCr: 'Service has finished' ]
			onFailure: [ :err | self inform: err messageText ];
		send: #spinOnce;
		to: self;
		inALocalProcess;
		start.
	1 second wait.
	jobExecution stop