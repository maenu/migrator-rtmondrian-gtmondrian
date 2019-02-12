Extension { #name : #GtSourceCoder }

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
GtSourceCoder >> migGtBrowseMatches: anElement [
	<typTypeArgument: 1 as: 'BlElement'>
	| source |
	source := self selectedSource.
	source isNil
		ifTrue: [ self typGtRbNodeAtCursor
				ifNil: [ ^ self ]
				ifNotNil: [ :e | source := e sourceCode ] ].
	anElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object:
					(MigGtMethodsFilter fromGtMondrian
						search: source;
						yourself);
				sourceElement: anElement)
]

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
GtSourceCoder >> migGtInitializeSourceAddOnsFor: anAst [
	<gtAstCoderAddOns: 12>
	addOns
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: BlKeyboardKey l;
						build);
				action: [ :e | self migGtBrowseMatches: e ])
]
