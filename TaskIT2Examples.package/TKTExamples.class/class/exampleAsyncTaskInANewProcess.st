examples - builder - async task
exampleAsyncTaskInANewProcess
	<example>
	| builder |
	builder := TKTBuilder new.
	builder
		asyncTask;
		onSuccess: [ :result | result inspect ] onFailure: [ :err | self inform: err messageText ];
		send: #yourself;
		to: 2;
		inALocalProcess;
		execute