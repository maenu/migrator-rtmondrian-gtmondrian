Class {
	#name : #MigGtSearchFilteredMethodsCoder,
	#superclass : #GtFilteredMethodsCoder,
	#instVars : [
		'pattern'
	],
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #private }
MigGtSearchFilteredMethodsCoder >> filters [
	^ {self implementorsFilter.
	self categoryFilter}
]

{ #category : #'initialize-release' }
MigGtSearchFilteredMethodsCoder >> forMethods: compiledMethods [
	super forMethods: compiledMethods.
	originalFilter := compiledMethods filter.
	implementorsFilterString := compiledMethods filter search.
	self updateCoders
]

{ #category : #private }
MigGtSearchFilteredMethodsCoder >> implementorsFilter [
	^ originalFilter
		search: implementorsFilterString;
		yourself
]

{ #category : #elements }
MigGtSearchFilteredMethodsCoder >> look [
	^ MigGtImplementorsFilterMethodsCoderLook new methodsCoder: self
]

{ #category : #accessing }
MigGtSearchFilteredMethodsCoder >> pattern [
	^ pattern
]

{ #category : #accessing }
MigGtSearchFilteredMethodsCoder >> pattern: anObject [
	pattern := anObject.
	methodCoders
		do: [ :e | 
			[ e migGtPatternBodyStyler pattern: anObject.
			e styleText ]
				on: NotFound
				do: [ "noop" ] ]
]

{ #category : #'as yet unclassified' }
MigGtSearchFilteredMethodsCoder >> scoreOf: aCoder [
	^ (implementorsFilterString migWords
		migMatchingRangesIn: (aCoder classOrMetaClass >> aCoder selector) ast) size
]

{ #category : #private }
MigGtSearchFilteredMethodsCoder >> shouldSort: a before: b [
	^ (self scoreOf: a) >= (self scoreOf: b)
]

{ #category : #private }
MigGtSearchFilteredMethodsCoder >> updateCoders [
	| newCoders highlighter |
	newCoders := methodCoders select: [ :each | each isModified ].
	methods
		do: [ :each | 
			(newCoders anySatisfy: [ :coder | coder isForMethod: each ])
				ifFalse: [ newCoders
						add:
							(methodCoders
								detect: [ :coder | coder isForMethod: each ]
								ifNone: [ self newMethodCoderFor: each ]) ] ].
	methodCoders := newCoders.
	methodCoders sort: [ :a :b | self shouldSort: a before: b ].
	methodCoders ifNotEmpty: [ methodCoders first expanded: true ]. "injected"
	highlighter := methods highlighter.
	methodCoders do: [ :each | each highlighter: highlighter ].
	self announce: (GtCoderMethodsListChanged new coder: self)
]
