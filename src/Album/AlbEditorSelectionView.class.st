Class {
	#name : #AlbEditorSelectionView,
	#superclass : #Object,
	#instVars : [
		'vertices',
		'selection'
	],
	#category : #'Album-UI'
}

{ #category : #'data source updates' }
AlbEditorSelectionView >> extentChangedIn: anInfiniteElement [

	self forceUpdate.
	self selectionChangedIn: anInfiniteElement
]

{ #category : #geometry }
AlbEditorSelectionView >> forceUpdate [

	selection := nil
]

{ #category : #'private ' }
AlbEditorSelectionView >> maxXRightCoord: yCoord fromRectangles: aListOfRectangles [

	| l |
	l := self rectanglesAtY: yCoord fromRectangles: aListOfRectangles.
	^ (l sort: [ :a :b | a right > b right ]) first right
]

{ #category : #geometry }
AlbEditorSelectionView >> minWidth [
	^ 4
]

{ #category : #'private ' }
AlbEditorSelectionView >> minXLeftCoord: yCoord fromRectangles: aListOfRectangles [

	| l |
	l := self rectanglesAtY: yCoord fromRectangles: aListOfRectangles.
	^ (l sort: [ :a :b | a left < b left ]) first left
]

{ #category : #'private ' }
AlbEditorSelectionView >> rectanglesAtY: anY fromRectangles: aListOfRectangles [

	| rectsAtYExcBottomLines |
	rectsAtYExcBottomLines := self rectsAtYExcBottomLines: anY fromRectangles: aListOfRectangles.
	rectsAtYExcBottomLines ifNotEmpty: [ ^ rectsAtYExcBottomLines ].
	^ self rectsAtYIncBottomLines: anY fromRectangles: aListOfRectangles
]

{ #category : #'private ' }
AlbEditorSelectionView >> rectsAtYExcBottomLines: anY fromRectangles: aListOfRectangles [

	^ aListOfRectangles select: [ :rect | rect top <= anY and: [ rect bottom > anY ] ]
]

{ #category : #'private ' }
AlbEditorSelectionView >> rectsAtYIncBottomLines: anY fromRectangles: aListOfRectangles [

	^ aListOfRectangles select: [ :rect | rect top <= anY and: [ rect bottom = anY ] ]
]

{ #category : #'data source updates' }
AlbEditorSelectionView >> selectionChangedIn: anInfiniteElement [

	| rects |
	selection = anInfiniteElement selection ifTrue: [ ^ self ].
	selection := anInfiniteElement selection copy.
	vertices := nil.
	rects := anInfiniteElement selectionRectangles , (self selectionLimitRectanglesIn: anInfiniteElement).
	rects ifEmpty: [ ^ self ].
	vertices := self verticesFromRectangles: rects
]

{ #category : #geometry }
AlbEditorSelectionView >> selectionLimitRectangleOf: anItemElement in: anInfiniteElement [

	" Select lines with cursor or with an element at left which has a selection that start at 0 "

	(anItemElement children
		 select: [ :e | 
			 (e isKindOf: BlTextElement) and: [ 
				 e bounds inParent left isZero and: [ e selection isNotEmpty and: [ e selection from isZero ] ] ] ]
		 thenCollect: [ :e | e textFlow assignedLine ]) in: [ :l | 
		l ifEmpty: [ ^ nil ].
		^ 0 @ l first origin y corner: self minWidth @ (l last origin y + l last height) ]
]

{ #category : #geometry }
AlbEditorSelectionView >> selectionLimitRectanglesIn: anInfiniteElement [

	^ Array streamContents: [ :stream | 
		  anInfiniteElement childrenDo: [ :child | 
			  | rect |
			  rect := self selectionLimitRectangleOf: child in: anInfiniteElement.
			  rect ifNotNil: [ stream nextPut: ((BlBounds fromRectangle: rect) translateBy: child bounds asRectangle origin)] ] ]
]

{ #category : #geometry }
AlbEditorSelectionView >> selectionScrolled: aPoint in: anInfiniteElement [

	self forceUpdate.
	self selectionChangedIn: anInfiniteElement
]

{ #category : #'private ' }
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

{ #category : #'private ' }
AlbEditorSelectionView >> yCoordsFromRectangles: aListOfRectangles [

	| allBotoms allTops allCoords |
	allBotoms := aListOfRectangles collect: [ :rect | rect bottom ].
	allTops := aListOfRectangles collect: [ :rect | rect top ].
	allCoords := Set new.
	allCoords addAll: allTops.
	allCoords addAll: allBotoms.
	^ allCoords asArray
]
