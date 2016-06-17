private -execution
startProcessResultFetcher
	^ (self -> #monitorAndFetchCommandOutput) tkt
		simpleTask;
		inALocalProcess;
		future