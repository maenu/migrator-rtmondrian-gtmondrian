Extension { #name : #String }

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
String >> migWords [
	| words |
	words := ' '
		split: (self asLowercase trimBoth copyWithRegex: '\s+' matchesReplacedWith: ' ').
	words ifEmpty: [ ^ #() ].
	(words size = 1 and: [ words first isEmpty ])
		ifTrue: [ ^ #() ].
	^ words
]
