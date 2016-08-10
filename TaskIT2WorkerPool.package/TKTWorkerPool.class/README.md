workerPool := MatraWorkerPool new.
workerPool poolSize: 5.
workerPool start.
workerPool schedule: [ Processor activeProcess identityHash ].