Class {
	#name : #MigGtRTMondrianExample,
	#superclass : #Object,
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #accessing }
MigGtRTMondrianExample >> example2015 [
	<gtExample>
	| b toBeRed |
	toBeRed := #(21 2 3 24 44 63 82 81 83 84 26 46 66 7 8 29 49 69 88 87 51 32 13 33 53 73 93 18 17 16 36 56 57 58 78 98 97 96).
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlEllipse new;
				size: 15 asPoint;
				background:
					(([ :value | toBeRed includes: value ] value: e)
						ifTrue: [ Color red ]
						ifFalse: [ Color veryLightGray alpha: 0.4 ]);
				yourself ];
		with: (1 to: 100).
	b edges
		connectToAll: [ :v | 
			v \\ 20 ~~ 0
				ifTrue: [ Array with: v + 1 with: v + 20 ]
				ifFalse: [ Array with: v + 20 ] ].
	b layout grid columnCount: 20.
	^ b
]
