actions
cancel
	job ifNotNil: [ job cancel: self ].
	cancelled := true.