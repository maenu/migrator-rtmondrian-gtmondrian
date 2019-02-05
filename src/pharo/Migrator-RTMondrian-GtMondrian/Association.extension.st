Extension { #name : #Association }

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
Association >> migDistance [
	^ (key isKindOf: Association)
		ifTrue: [ key migDistance + (value - key value) ]
		ifFalse: [ value - key ]
]
