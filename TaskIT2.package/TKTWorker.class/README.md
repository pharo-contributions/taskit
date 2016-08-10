worker := MatraWorker new.
worker start.
future := worker schedule: [ 2 + 2 ].
future value.