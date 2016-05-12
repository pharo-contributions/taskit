Meanwhile the SynchronousSimpleJob returns a Future, this one returns a simple job execution that allows to rewrite as many times as needed the callbacks for success and failure in processing. 

Use this kind of job when you want to be called to the end of the process. 

The main difference with this job is that if this job is garbage collected the process will not finish. Then you can discard the object after configuring the callbacks 