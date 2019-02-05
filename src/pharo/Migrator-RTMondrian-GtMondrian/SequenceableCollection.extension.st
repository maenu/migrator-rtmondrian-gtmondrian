Extension { #name : #SequenceableCollection }

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
SequenceableCollection >> migMatches: aNode [
	self ifEmpty: [ ^ true ].
	^ aNode sourceCode asLowercase
		matchesRegex: '.*' , ('.*' join: self) , '.*'
]

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
SequenceableCollection >> migMatchingRangesIn: aNode [
	| source |
	self ifEmpty: [ ^ #() ].
	source := aNode sourceCode asLowercase.
	^ self flatCollect: [ :e | source allRangesOfRegexMatches: e ]
]
