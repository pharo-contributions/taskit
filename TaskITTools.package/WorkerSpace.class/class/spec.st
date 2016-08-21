accessing
spec
	<spec: #default>

	^ SpecLayout composed newColumn: [:column |
		column newRow: #codeArea ].