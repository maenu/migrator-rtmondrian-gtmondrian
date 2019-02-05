Class {
	#name : #MigGtSearchFilteredMethodsCoder,
	#superclass : #GtFilteredMethodsCoder,
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #'initialize-release' }
MigGtSearchFilteredMethodsCoder >> forMethods: compiledMethods [
	super forMethods: compiledMethods.
	self updateCoders
]

{ #category : #private }
MigGtSearchFilteredMethodsCoder >> implementorsFilter [
	^ (implementorsFilterString notNil
		and: [ implementorsFilterString notEmpty ])
		ifTrue: [ MigGtMethodsFilter new
				search: implementorsFilterString;
				yourself ]
]

{ #category : #'as yet unclassified' }
MigGtSearchFilteredMethodsCoder >> scoreOf: aCoder [
	^ implementorsFilterString
		ifNil: [ 9999 ]
		ifNotNil: [ | matches |
			matches := (implementorsFilterString
				migMatchesIn: (aCoder classOrMetaClass >> aCoder selector) ast)
				reject: #isEmpty.
			matches
				ifEmpty: [ 9999 ]
				ifNotEmpty: [ (matches collect: [ :e | e collect: #first ]) migMin ] ]
]

{ #category : #private }
MigGtSearchFilteredMethodsCoder >> shouldSort: a before: b [
	^ (self scoreOf: a) <= (self scoreOf: b)
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
