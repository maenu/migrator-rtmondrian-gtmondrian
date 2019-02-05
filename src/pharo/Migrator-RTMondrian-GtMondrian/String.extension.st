Extension { #name : #String }

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
String >> migBeginningRangeWith: aString ignoringWhitespaceAndCaseAt: anInteger [
	| whitespace cursor first last |
	self size - anInteger + 1 < aString size
		ifTrue: [ ^ nil ].
	cursor := anInteger.
	first := anInteger.
	last := anInteger.
	whitespace := {Character space.
	Character tab.
	Character lf.
	Character cr}.
	aString asLowercase
		withIndexDo: [ :e :i | 
			| j |
			j := cursor + i - 1.
			[ j <= self size and: [ whitespace includes: (self at: j) ] ]
				whileTrue: [ cursor := cursor + 1.
					j := j + 1 ].
			j <= self size
				ifFalse: [ ^ nil ].
			(self at: j) asLowercase ~= e
				ifTrue: [ ^ nil ]
				ifFalse: [ i = 1
						ifTrue: [ first := j ].
					last := j ] ].
	^ first to: last
]

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
String >> migMatchesIn: aNode [
	| words matches source sourceCursor maxMatchIndex |
	words := ' '
		split: (self trimBoth copyWithRegex: '\s+' matchesReplacedWith: ' ').
	words ifEmpty: [ ^ #() ].
	(words size = 1 and: [ words first isEmpty ])
		ifTrue: [ ^ #() ].
	matches := OrderedCollection new.
	source := aNode sourceCode.
	sourceCursor := 1.
	maxMatchIndex := 1.
	[ sourceCursor <= source size ]
		whileTrue: [ words
				withIndexDo: [ :f :j | 
					j <= maxMatchIndex
						ifTrue: [ (source
								migBeginningRangeWith: f
								ignoringWhitespaceAndCaseAt: sourceCursor)
								ifNotNil: [ :g | 
									sourceCursor := g last + 1.
									matches add: j -> f -> g.
									maxMatchIndex := maxMatchIndex max: j + 1 ] ] ].
			sourceCursor := sourceCursor + 1 ].
	maxMatchIndex <= words size
		ifTrue: [ ^ #() ].
	^ matches
]
