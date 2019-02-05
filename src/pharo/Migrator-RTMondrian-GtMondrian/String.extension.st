Extension { #name : #String }

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
String >> migMatchesIn: aNode [
	| words |
	words := ' '
		split: (self asLowercase copyWithRegex: '\s+' matchesReplacedWith: ' ').
	^ words
		collect: [ :e | aNode sourceCode asLowercase allRangesOfSubstring: e ]
]
