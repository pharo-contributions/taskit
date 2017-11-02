printing
printOn: aStream
	| freeWorkers | 
	freeWorkers := workers select: #isFree.
	aStream
		nextPutAll: 'TKTWorkerPool(';
		nextPutAll: 'poolMaxSize: ';
		print: poolMaxSize;
		nextPutAll: '; busyWorkers: ';
		print: workers size - freeWorkers size;
		nextPutAll: '; freeWorkers: ';
		print: freeWorkers size;
		nextPutAll: ')'