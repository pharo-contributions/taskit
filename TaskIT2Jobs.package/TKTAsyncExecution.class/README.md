An Async Execution is a kind of execution that allows to set callbacks for relating with the execution. 

Async Exeuction allows to add all the callbacks you want to onSuccess and onFailure. Each time you call any of these methods: 

onSuccess
 	-  The callback is added to a collection of callbacks. 
	- If the result of the execution is already deployed and is a success, the callback is called with this value. 
onFailure
 	-  The callback is added to a collection of callbacks. 
	- If the result of the execution is already deployed and is a failure, the callback is called with the deployed exception. 
	


In order to gurantee  the execution of the callbacks, we use a non-weak message send as a callback in between the task execution and the job execution. Meaning that if the reference of the jobExecution, it will not be garbage collected up to the end of the execution of the related task.