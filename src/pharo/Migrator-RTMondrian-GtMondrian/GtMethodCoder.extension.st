Extension { #name : #GtMethodCoder }

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
GtMethodCoder >> migGtBrowseMigratedMethod: anElement [
	<typTypeArgument: 1 as: 'BlElement'>
	(self classOrMetaClass migMigratedClass
		includesSelector: self selector)
		ifFalse: [ self classOrMetaClass migMigratedClass compile: self source ].
	anElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object:
					(MigGtMethodsFilter fromGtRTMondrian
						search: self selector;
						yourself);
				sourceElement: anElement)
]

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
GtMethodCoder >> migGtInitializeMethodAddOnsFor: anAst [
	<gtAstCoderAddOns: 13>
	addOns
		addStyler: MigGtSearchBodyStyler new;
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key k;
						build);
				action: [ :e | self migGtBrowseMigratedMethod: e ])
]

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
GtMethodCoder >> migGtSearchBodyStyler [
	^ addOns stylers
		detect: [ :e | e class = MigGtSearchBodyStyler ]
		ifNone: [ nil ]
]

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
GtMethodCoder >> migMethodSource: aString [
	methodSource := aString.
	astCache := nil -> nil.
	self buildSource
]
