Class {
	#name : #AlbPrimarySelectionElement,
	#superclass : #AlbAbstractSubtextElement,
	#category : #'Album-UI-Text-Portion'
}

{ #category : #accessing }
AlbPrimarySelectionElement >> defaultBackground [

	^ (Color
		   r: 0.9530791788856305
		   g: 0.8084066471163245
		   b: 0.1906158357771261
		   alpha: 1.0) asBlBackground
]

{ #category : #initialization }
AlbPrimarySelectionElement >> defaultBorder [ 

	^ (BlBorderBuilder new
			 paint: self defaultBackground paint color twiceDarker;
			 width: self borderWidth;
			 lineCap: BlStrokeLineCap round;
			 build).
]

{ #category : #initialization }
AlbPrimarySelectionElement >> defaultGeometry [
	
	^ BlRoundedPolygonGeometry new radius: 5
	"^ BlPolygonGeometry new"
]

{ #category : #initialization }
AlbPrimarySelectionElement >> initialize [

	super initialize.
	self addEventHandler: AlbSubtextElementEventHandler new.
	self border: self defaultBorder 
]

{ #category : #private }
AlbPrimarySelectionElement >> selectionRectangles [
	"return all selections rectangles from coordinate system of text elements with selection to my local coordinates"

	editorElement mode
		ifWithPrimarySelectionDo: [
			^ Array streamContents: [ :stream |
				  editorElement textElementsDo: [ :te |
					  te selectionRectangles do: [ :r |
						  stream nextPut: ((editorElement
								    localBoundsToMine: (BlBounds fromRectangle: r)
								    fromChild: te) translateBy: 0 @ te position y negated) ] ] ] ]
		ifNot: [ ^ #(  ) ]
]

{ #category : #initialization }
AlbPrimarySelectionElement >> updateVertices [

	self vertices: ( BlVerticesFromRectanglesOperator new verticesFromRectangles: self selectionRectangles )
]
