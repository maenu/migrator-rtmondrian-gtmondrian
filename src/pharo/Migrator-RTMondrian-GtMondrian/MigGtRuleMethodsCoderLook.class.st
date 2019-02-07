Class {
	#name : #MigGtRuleMethodsCoderLook,
	#superclass : #GtImplementorsFilterMethodsCoderLook,
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> applyButtonWithSearch: aCoder replace: anotherCoder [
	^ BrButton new
		look: BrGlamorousButtonWithLabelLook;
		label: 'Apply';
		action: [ methodsCoder coders
				do: [ :e | 
					| ast |
					ast := e rbAST.
					ast
						acceptVisitor:
							(MigRBReplaceNodeVisitor new
								search: aCoder evaluateAndHighlightAllSource;
								replace: anotherCoder evaluateAndHighlightAllSource;
								yourself).
					e migMethodSource: ast formattedCode ] ];
		yourself
]

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> initializeLook [
	| methodsList index search match replace apply |
	super initializeLook.
	methodsList := self widget childNamed: #methodsList.
	index := self widget childIndexOf: methodsList.
	search := self searchCoder.
	match := self matchButtonWithSearch: search.
	replace := self replaceCoder.
	apply := self applyButtonWithSearch: search replace: replace.
	self widget
		addChild: apply at: index;
		addChild: replace asElement at: index;
		addChild: match at: index;
		addChild: search asElement at: index
]

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> matchButtonWithSearch: aCoder [
	^ BrButton new
		look: BrGlamorousButtonWithLabelLook;
		label: 'Match';
		action: [ | block |
			block := aCoder evaluateAndHighlightAllSource.
			(block isKindOf: BlockClosure)
				ifTrue: [ methodsCoder methodCoders
						do: [ :e | 
							e migGtSearchBodyStyler
								ifNotNil: [ :f | 
									f block: block.
									e styleText ] ] ] ];
		yourself
]

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> replaceCoder [
	| coder |
	coder := GtPharoSnippetCoder new
		source: '[ :e | e ]';
		yourself.
	^ coder
]

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> searchCoder [
	| coder |
	coder := GtPharoSnippetCoder new
		source: '[ :e | false ]';
		yourself.
	^ coder
]
