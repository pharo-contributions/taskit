instance-creation
createProcessDoing: aValuable

	^ (TKTProcess send: #value to: aValuable)
		annotate: #task with: aValuable;
		resume