private
filteredCombinedStack
	^ self filteredSlaveStack
		addAll: self filteredMasterStack;
		yourself