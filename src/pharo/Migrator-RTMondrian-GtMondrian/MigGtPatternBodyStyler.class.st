Class {
	#name : #MigGtPatternBodyStyler,
	#superclass : #GtCoderBodyStyler,
	#instVars : [
		'nodes',
		'pattern'
	],
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #initialization }
MigGtPatternBodyStyler >> initialize [
	super initialize.
	nodes := IdentitySet new
]

{ #category : #accessing }
MigGtPatternBodyStyler >> pattern [
	^ pattern
]

{ #category : #accessing }
MigGtPatternBodyStyler >> pattern: anObject [
	pattern := anObject
]

{ #category : #styling }
MigGtPatternBodyStyler >> style: aText ast: ast [
	pattern isEmptyOrNil
		ifTrue: [ ^ self ].
	nodes := RBParseTreeSearcher new
		matches: pattern
			do: [ :e :f | 
			f
				add: e;
				yourself ];
		executeTree: ast initialAnswer: IdentitySet new.
	super style: aText ast: ast
]

{ #category : #visiting }
MigGtPatternBodyStyler >> visitNode: aNode [
	super visitNode: aNode.
	(nodes includes: aNode)
		ifTrue: [ self
				styleFrom: aNode start
				to: aNode stop
				with: {(BlTextUnderlineAttribute new paint: (Color green alpha: 0.5))} ]
]
