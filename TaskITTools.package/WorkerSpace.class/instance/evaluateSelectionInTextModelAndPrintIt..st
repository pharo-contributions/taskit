actions
evaluateSelectionInTextModelAndPrintIt: text

	text textMorph editor lineSelectAndEmptyCheck: [ ^ '' ].
	worker schedule: [ | result printString |
		UIManager default defer: [ 
			window removeMorph: text.
			window addMorphCentered: self waitImage ].
		result := OpalCompiler evaluate: text textMorph selection.
		printString := [ result printString ]
				on: Error
				do: [ '<error in printString: try ''Inspect it'' to debug>' ].
		UIManager default defer: [ 
			window removeMorph: self waitImage.
			text textMorph editor afterSelectionInsertAndSelect: printString.
			window addMorph: text  ].
	]