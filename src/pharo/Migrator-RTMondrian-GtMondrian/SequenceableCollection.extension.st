Extension { #name : #SequenceableCollection }

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
SequenceableCollection >> migMin [
	self assert: [ self allSatisfy: #isCollection ].
	^ self size = 1
		ifTrue: [ self min ]
		ifFalse: [ | rest |
			rest := self allButFirst.
			(self first collect: [ :e | rest migMinTo: e ]) migMin ]
]

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
SequenceableCollection >> migMinTo: anInteger [
	^ ((self reject: [ :e | e < anInteger ])
		sorted: [ :a :b | a - anInteger < (b - anInteger) ]) ifEmpty: [ 9999 ] ifNotEmpty: #first
]
