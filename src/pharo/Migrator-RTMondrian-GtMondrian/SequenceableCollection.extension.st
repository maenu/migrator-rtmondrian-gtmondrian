Extension { #name : #SequenceableCollection }

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
SequenceableCollection >> migMin [
	self assert: [ self allSatisfy: #isCollection ].
	^ self size = 1
		ifTrue: [ self min ]
		ifFalse: [ | first rest |
			rest := self.
			first := rest first.
			rest := rest allButFirst.
			[ rest isNotEmpty ]
				whileTrue:
					[ first := first collect: [ :e | e -> (rest first migMinTo: e value) ].
					rest := rest allButFirst ].
			(first collect: #migDistance) min ]
]

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
SequenceableCollection >> migMinTo: anInteger [
	^ ((self reject: [ :e | e < anInteger ])
		sorted: [ :a :b | (a - anInteger) abs <= (b - anInteger) abs ])
		ifEmpty: [ 9999 ]
		ifNotEmpty: #first
]
