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
		addStyler: MigGtPatternBodyStyler new;
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
GtMethodCoder >> migGtPatternBodyStyler [
	^ addOns stylers detect: [ :e | e class = MigGtPatternBodyStyler ]
]

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
GtMethodCoder >> migMethodSource: aString [
Halt once. 
	methodSource := aString.
	astCache := nil -> nil.
	self buildSource
]