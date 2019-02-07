Class {
	#name : #MigRBReplaceNodeVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'search',
		'replace'
	],
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #accessing }
MigRBReplaceNodeVisitor >> replace [
	^ replace
]

{ #category : #accessing }
MigRBReplaceNodeVisitor >> replace: anObject [
	replace := anObject
]

{ #category : #accessing }
MigRBReplaceNodeVisitor >> search [
	^ search
]

{ #category : #accessing }
MigRBReplaceNodeVisitor >> search: anObject [
	search := anObject
]

{ #category : #visiting }
MigRBReplaceNodeVisitor >> visitNode: aNode [
	| node |
	node := aNode.
	(search value: node)
		ifTrue: [ node := replace value: node ].
	aNode replaceWith: node.
	^ super visitNode: node
]
