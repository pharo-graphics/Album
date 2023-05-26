Class {
	#name : #AlbPrimarySelectionElement,
	#superclass : #AlbAbstractSubtextElement,
	#category : #'Album-UI-Text-Portion'
}

{ #category : #initialization }
AlbPrimarySelectionElement >> defaultUpdateStrategy [

	^ AlbPrimarySelectionElementUpdateStrategy new
]

{ #category : #initialization }
AlbPrimarySelectionElement >> initialize [

	super initialize.
	
	self background: self editorElement selectionColor.
	
	self border: (BlBorderBuilder new 
		paint: self editorElement selectionColor twiceDarker; 
		width: self borderWidth; 
		lineCap: BlStrokeLineCap round; 
		build).
		
	self outskirts: BlOutskirts centered
]

{ #category : #private }
AlbPrimarySelectionElement >> onGotFocus [

	self background: editorElement selectionColor.
	self border:	(BlBorder paint: editorElement selectionColor twiceDarker  width: self borderWidth)
]

{ #category : #private }
AlbPrimarySelectionElement >> onLostFocus [

	self background: (editorElement selectionColor alpha: 0.1)
]

{ #category : #private }
AlbPrimarySelectionElement >> selectionRectangles [

	"return all selections rectangles from coordinate system of text elements with selection to my local coordinates"

	^ Array streamContents: [ :stream | 
		  editorElement textElementsDo: [ :te | 
			  te selectionRectangles do: [ :r | 
					stream nextPut: ((editorElement localBoundsToMine: (BlBounds fromRectangle: r) fromChild: te) translateBy: 0 @ (te position y) negated ) ] ] ]
]

{ #category : #initialization }
AlbPrimarySelectionElement >> updateVertices [

	editorElement ifNil: [ ^ self ].
	self selectionRectangles 
		ifEmpty: [ self parentDo: [ :p | self removeFromParent ] ]
		ifNotEmpty: [ :rects |
			self vertices: (OBlVerticesFromRectanglesOperator new verticesFromRectangles: rects).
			self hasParent ifFalse: [ editorElement addChild: self ] ]
]
