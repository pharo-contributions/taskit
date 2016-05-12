sugar - examples - builder - async task
exampleAsyncTaskInANewProcessSugar
	<example>
	(2 -> #yourself) tkt
		asyncTask;
		onSuccess: [ :result | result inspect ] onFailure: [ :err | self inform: err messageText ];
		inALocalProcess;
		execute