sugar - examples - builder - async task
exampleAsyncTaskInCallingProcessSugar
	<example>
	(2 -> #yourself) tkt
		asyncTask;
		onSuccess: [ :result | result inspect ] onFailure: [ :err | self inform: err messageText ];
		send: #yourself;
		to: 2;
		inThisProcess;
		execute