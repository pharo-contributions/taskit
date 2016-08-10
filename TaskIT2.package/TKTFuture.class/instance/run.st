running
run

	[ [ self deploySuccess: (block cull: self) ] 
		on: Error
		do: [ :exception | self deployFailure: exception ] ] fork.