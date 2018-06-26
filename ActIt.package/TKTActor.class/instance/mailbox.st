accessing
mailbox
	^ runner queue copy
		beReadOnlyObject;
		yourself