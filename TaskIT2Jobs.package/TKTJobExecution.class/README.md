As the TaskExecution reifies the runtime of a Task, JobExecution does the same for a Job. 
In this case, this runtime relates a job, a runner and a task execution. 

Since this object is the link in between the user and the processing stuff, if it is garbage collected, it will stop all related process.