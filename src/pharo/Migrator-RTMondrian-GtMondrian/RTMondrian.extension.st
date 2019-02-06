Extension { #name : #RTMondrian }

{ #category : #'*Migrator-RTMondrian-GtMondrian' }
RTMondrian >> migGtView: aView [
	<gtView>
	^ aView explicit
		title: 'Morph';
		priority: 1;
		stencil: [ BlElement new
				layout: BlLinearLayout vertical;
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ];
				padding: (BlInsets all: 5);
				addChild:
					(BrButton new
						look: BrGlamorousButtonWithLabelLook;
						label: 'Inspect in Morphic';
						action: [ GTInspector inspect: self view ];
						yourself);
				addChild: self view setUpCanvas buildMorph imageForm asElement;
				yourself ]
]
