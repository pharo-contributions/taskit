view
open

	| model text |
	model := RubScrolledTextModel new interactionModel: self.
	text := model newScrolledText
			beForSmalltalkCode;
			withCodeSizeFeedback.

	text textMorph
		bindKeyCombination: $d meta
		toAction: [ self evaluateSelectionInTextModel: text ].
		
	text textMorph
		bindKeyCombination: $p meta
		toAction: [ self evaluateSelectionInTextModelAndPrintIt: text ].

	window := (SystemWindow labelled: 'Mister Postman')
		addMorph: text frame: (0@0 corner: 1@1);
		openInWorld.