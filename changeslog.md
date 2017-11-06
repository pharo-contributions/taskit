# v0.4

## Major Features

- Task Runners
  - CommonQueuePool + WatchDog   Issue #30
  - TKTDebuggWorkerProcess - Allows debugging in worker.
- Debugger - Max Leske Debugging support.
- Service moves to the core (Neede for implementing watchdog) 


## Infrastructure

- [Travis CI](https://travis-ci.org/sbragagnolo/taskit)
- [Documentation](https://github.com/sbragagnolo/taskit/blob/master/README.md)

## Minor changes log (from commits)

- TKTConfiguration for all the general defaults. 
- Baseline and package fixing for loading properly de debugger (Issue #29)
 

# v0.2

## Major Features

- Task Runners
  - NewProcessTaskRunner
  - LocalProcessTaskRunner
  - Worker
  - WorkerPool
- Futures with callbacks
- Future combinators
- Future synchronous access
- Services

## Infrastructure

- [Travis CI](https://travis-ci.org/sbragagnolo/taskit)
- [Documentation](https://github.com/sbragagnolo/taskit/blob/master/README.md)

## Minor changes log (from commits)

- Enhanced class comments
- TKTWorker processes are terminated in case the worker is collected. See Issues #8 and #5
- Process Dashboard
  - Adds TKTTaskItProcessProvider by default with the extension package
  - Hides job and task fields since there are not reachable any more
