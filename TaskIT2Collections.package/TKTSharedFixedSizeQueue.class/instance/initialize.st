initialization
initialize
	super initialize.
	queue := SharedQueue new.
	blocking := true.
	size := 1.