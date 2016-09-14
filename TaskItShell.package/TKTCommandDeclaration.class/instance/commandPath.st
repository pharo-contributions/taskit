building
commandPath

	^ ({command asFileReference.
	(#/ asFileReference / #usr / #bin / command).
	(#/ asFileReference / #bin / command)} select: #exists) first fullName