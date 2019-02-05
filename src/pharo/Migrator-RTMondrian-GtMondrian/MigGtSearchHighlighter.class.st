Class {
	#name : #MigGtSearchHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'search'
	],
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #accessing }
MigGtSearchHighlighter >> search [
	^ search
]

{ #category : #accessing }
MigGtSearchHighlighter >> search: anObject [
	search := anObject
]

{ #category : #visiting }
MigGtSearchHighlighter >> visitNode: aNode [
	search
		ifNotNil: [ ((search migMatchesIn: aNode) flatCollect: #yourself)
				do: [ :e | 
					((e first between: 1 and: text size)
						and: [ e last between: 1 and: text size ])
						ifTrue: [ self styleFrom: e first to: e last with: HighlightAttributes ] ] ]
]
