run
beRunnedBy: aTKTRunner
	| future |
	future := TKTFuture on: self.
	aTKTRunner
		run: task
		onSuccess: (self onSuccessFor: future)
		onFailure: (self onFailureFor: future)
		onError: (self onErrorFor: future).
	^ future