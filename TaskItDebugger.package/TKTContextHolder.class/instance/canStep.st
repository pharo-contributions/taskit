testing
canStep
	^ self isDead not and: [
		self process suspendedContext notNil and: [
			self hasNext and: [
				self next isDead not ] ] ]