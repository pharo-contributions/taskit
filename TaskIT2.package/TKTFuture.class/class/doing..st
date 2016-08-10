instance-creation
doing: aBlock

	^ self new
		block: aBlock;
		run;
		yourself