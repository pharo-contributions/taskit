private -execution
startProcessAsyncFetcher
	^ (self -> #monitorAndFetchCommandOutput) tkt
		asyncTask;
		inALocalProcess;
		execute