as yet unclassified
taskQueue: anAtomicSharedQueue
	queue := anAtomicSharedQueue.
	process ifNotNil: [ process taskQueue: queue ]