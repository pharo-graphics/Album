Class {
	#name : #AlbTextPortionElement,
	#superclass : #BlElement,
	#category : #'Album-UI'
}

{ #category : #'infinite element changes' }
AlbTextPortionElement >> adjacentRectangles: aCollection [

	self vertices: (self verticesFromRectangles: aCollection)
]

{ #category : #accessing }
AlbTextPortionElement >> borderWidth [

	^ 1
]

{ #category : #initialization }
AlbTextPortionElement >> initialize [ 

	super initialize.
	self vertices: #().
	visuals := BlCustomVisuals new geometry: BlPolygonGeometry new.
	self constraintsDo: [ :c | c ignoreByLayout  ].
	self outskirts: (BlOutskirts centered).


]

{ #category : #'private - vertices computing' }
AlbTextPortionElement >> maxXRightCoord: yCoord fromRectangles: aListOfRectangles [
	" optimized with compiled in-line primitives "

	| l mostRight |
	l := self rectanglesAtY: yCoord fromRectangles: aListOfRectangles.
	mostRight := l first right.
	2 to: l size do: [ :pos | mostRight := mostRight max: (l at: pos) right ].
	^ mostRight
]

{ #category : #'private - vertices computing' }
AlbTextPortionElement >> minXLeftCoord: yCoord fromRectangles: aListOfRectangles [
	"optimized with compiled in-line primitives "

	| l mostLeft |
	l := self rectanglesAtY: yCoord fromRectangles: aListOfRectangles.
	mostLeft := l first left.
	2 to: l size do: [ :pos | mostLeft := mostLeft min: (l at: pos) left ].
	^ mostLeft
]

{ #category : #'private - vertices computing' }
AlbTextPortionElement >> rectanglesAtY: anY fromRectangles: aListOfRectangles [

	| rectsAtYExcBottomLines |
	rectsAtYExcBottomLines := self rectsAtYExcBottomLines: anY fromRectangles: aListOfRectangles.
	rectsAtYExcBottomLines ifNotEmpty: [ ^ rectsAtYExcBottomLines ].
	^ self rectsAtYIncBottomLines: anY fromRectangles: aListOfRectangles
]

{ #category : #'private - vertices computing' }
AlbTextPortionElement >> rectsAtYExcBottomLines: anY fromRectangles: aListOfRectangles [

	^ Array streamContents: [ :stream | aListOfRectangles do: [ :rect |
			(rect top <= anY and: [ rect bottom > anY ]) ifTrue: [ stream nextPut: rect ] ]]
]

{ #category : #'private - vertices computing' }
AlbTextPortionElement >> rectsAtYIncBottomLines: anY fromRectangles: aListOfRectangles [

	^ Array streamContents: [ :stream | aListOfRectangles do: [ :rect |
			(rect top <= anY and: [ rect bottom = anY ]) ifTrue: [ stream nextPut: rect ] ]]
]

{ #category : #accessing }
AlbTextPortionElement >> vertices: aCollectionOfPoints [

	aCollectionOfPoints ifEmpty: [ ^ self ].
	self geometry vertices: aCollectionOfPoints 
]

{ #category : #'private - vertices computing' }
AlbTextPortionElement >> verticesFromRectangles: aListOfRectangles [

	| ret yCoords previousLeftCoord previousRightCoord |
	ret := OrderedCollection new.
	yCoords := self yCoordsFromRectangles: aListOfRectangles.
	yCoords := yCoords sort: [ :a :b | a < b ].
	previousLeftCoord := 0.
	previousRightCoord := 0.
	yCoords do: [ :yCoord | 
		| minimumXLeftCoord maximumXRightCoord first |
		minimumXLeftCoord := self minXLeftCoord: yCoord fromRectangles: aListOfRectangles.
		maximumXRightCoord := self maxXRightCoord: yCoord fromRectangles: aListOfRectangles.
		first := yCoords first.
		yCoord = yCoords first
			ifTrue: [ ret add: minimumXLeftCoord @ yCoord ]
			ifFalse: [ 
				minimumXLeftCoord ~= previousLeftCoord ifTrue: [ ret add: previousLeftCoord @ yCoord beforeIndex: 1 ].
				ret add: minimumXLeftCoord @ yCoord beforeIndex: 1.
				maximumXRightCoord ~= previousRightCoord ifTrue: [ ret add: previousRightCoord @ yCoord ] ].
		ret add: maximumXRightCoord @ yCoord.
		previousLeftCoord := minimumXLeftCoord.
		previousRightCoord := maximumXRightCoord ].
	^ ret
]

{ #category : #'private - vertices computing' }
AlbTextPortionElement >> yCoordsFromRectangles: aListOfRectangles [

	| allBotoms allTops allCoords |
	allBotoms := aListOfRectangles collect: [ :rect | rect bottom ].
	allTops := aListOfRectangles collect: [ :rect | rect top ].
	allCoords := Set new.
	allCoords addAll: allTops.
	allCoords addAll: allBotoms.
	^ allCoords asArray
]
