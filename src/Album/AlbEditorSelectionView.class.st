Class {
	#name : #AlbEditorSelectionView,
	#superclass : #Object,
	#instVars : [
		'vertices'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbEditorSelectionView >> background [
	^ BlPaintBackground paint: self selectionColor
]

{ #category : #accessing }
AlbEditorSelectionView >> border [
	^ BlBorder paint: self borderColor width: 2
]

{ #category : #accessing }
AlbEditorSelectionView >> borderColor [
	^ self subclassResponsibility 
]

{ #category : #accessing }
AlbEditorSelectionView >> geometry [
	^ BlPolygonGeometry vertices: vertices.
]

{ #category : #'private - vertices computing' }
AlbEditorSelectionView >> maxXRightCoord: yCoord fromRectangles: aListOfRectangles [

	| l |
	l := self rectanglesAtY: yCoord fromRectangles: aListOfRectangles.
	^ (l sort: [ :a :b | a right > b right ]) first right
]

{ #category : #'private - vertices computing' }
AlbEditorSelectionView >> minXLeftCoord: yCoord fromRectangles: aListOfRectangles [

	| l |
	l := self rectanglesAtY: yCoord fromRectangles: aListOfRectangles.
	^ (l sort: [ :a :b | a left < b left ]) first left
]

{ #category : #'private - vertices computing' }
AlbEditorSelectionView >> rectanglesAtY: anY fromRectangles: aListOfRectangles [

	| rectsAtYExcBottomLines |
	rectsAtYExcBottomLines := self rectsAtYExcBottomLines: anY fromRectangles: aListOfRectangles.
	rectsAtYExcBottomLines ifNotEmpty: [ ^ rectsAtYExcBottomLines ].
	^ self rectsAtYIncBottomLines: anY fromRectangles: aListOfRectangles
]

{ #category : #'private - vertices computing' }
AlbEditorSelectionView >> rectsAtYExcBottomLines: anY fromRectangles: aListOfRectangles [

	^ aListOfRectangles select: [ :rect | rect top <= anY and: [ rect bottom > anY ] ]
]

{ #category : #'private - vertices computing' }
AlbEditorSelectionView >> rectsAtYIncBottomLines: anY fromRectangles: aListOfRectangles [

	^ aListOfRectangles select: [ :rect | rect top <= anY and: [ rect bottom = anY ] ]
]

{ #category : #accessing }
AlbEditorSelectionView >> selectionColor [
	^ self subclassResponsibility 
]

{ #category : #'selection accessing' }
AlbEditorSelectionView >> selectionRectanglesIn: anInfiniteElement [

	^ #(  )
]

{ #category : #accessing }
AlbEditorSelectionView >> selectionScrolled: aPoint in: anInfiniteElement [
	vertices ifNil: [ ^self ].
	vertices := vertices collect: [ :pt | pt - aPoint ]
]

{ #category : #accessing }
AlbEditorSelectionView >> vertices: aListOfRectangles [
	vertices := aListOfRectangles
]

{ #category : #'private - vertices computing' }
AlbEditorSelectionView >> verticesFromRectangles: aListOfRectangles [

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
AlbEditorSelectionView >> yCoordsFromRectangles: aListOfRectangles [

	| allBotoms allTops allCoords |
	allBotoms := aListOfRectangles collect: [ :rect | rect bottom ].
	allTops := aListOfRectangles collect: [ :rect | rect top ].
	allCoords := Set new.
	allCoords addAll: allTops.
	allCoords addAll: allBotoms.
	^ allCoords asArray
]
