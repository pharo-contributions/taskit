as yet unclassified
setUp
	runner := TKTLocalProcessRunner new.
	task := TKTTask receiver: self selector: #divideBy0.

	