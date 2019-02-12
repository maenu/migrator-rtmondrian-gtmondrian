Class {
	#name : #MigGtSearchBodyStyler,
	#superclass : #GtCoderBodyStyler,
	#instVars : [
		'block'
	],
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #accessing }
MigGtSearchBodyStyler >> block [
	^ block
]

{ #category : #accessing }
MigGtSearchBodyStyler >> block: anObject [
	block := anObject
]

{ #category : #initialization }
MigGtSearchBodyStyler >> initialize [
	super initialize.
	block := [ :e | false ]
]

{ #category : #private }
MigGtSearchBodyStyler >> styleFrom: from to: to with: attributes [
	((from between: 1 and: text size)
		and: [ to between: 1 and: text size ])
		ifTrue: [ super styleFrom: from to: to with: attributes ]
]

{ #category : #visiting }
MigGtSearchBodyStyler >> visitNode: aNode [
	| value |
	aNode typIsTyped ifFalse: [ ^ self ].
	value := block value: aNode.
	value = true
		ifTrue: [ self
				styleFrom: aNode start
				to: aNode stop
				with: {(BlTextUnderlineAttribute new paint: (Color green alpha: 0.5))} ].
	super visitNode: aNode.
]
