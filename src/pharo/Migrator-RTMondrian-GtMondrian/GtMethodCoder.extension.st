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
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key k;
						build);
				action: [ :e | self migGtBrowseMigratedMethod: e ])
]
