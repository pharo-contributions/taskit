actions
evaluateSelectionInTextModel: text

	text textMorph editor lineSelectAndEmptyCheck: [ ^ '' ].
	worker schedule: [
		UIManager default defer: [ 
			window removeMorph: text.
			window addMorphCentered: self waitImage ].
		OpalCompiler evaluate: text textMorph selection.
		UIManager default defer: [ 
			window removeMorph: self waitImage.
			window addMorph: text  ].
	]