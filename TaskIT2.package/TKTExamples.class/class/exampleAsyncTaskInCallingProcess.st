examples - builder - async task
exampleAsyncTaskInCallingProcess
	<example>
	| builder |
	builder := TKTBuilder new.
	builder
		asyncTask;
		onSuccess: [ :result | result inspect ] onFailure: [ :err | self inform: err messageText ];
		send: #yourself;
		to: 2;
		inThisProcess;
		execute