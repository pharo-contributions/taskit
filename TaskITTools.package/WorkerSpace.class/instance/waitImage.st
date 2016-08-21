view
waitImage

	^ waitImage ifNil: [
		waitImage := ImageMorph withForm: (Form fromBinaryStream: self waitImageEncodedBase64 base64Decoded asByteArray readStream) ]