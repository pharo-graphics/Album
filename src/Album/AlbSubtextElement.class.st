Class {
	#name : #AlbSubtextElement,
	#superclass : #AlbTextDecorationElement,
	#instVars : [
		'editorElement',
		'extentHandler',
		'scrollHandler'
	],
	#category : #'Album-UI'
}

{ #category : #private }
AlbSubtextElement >> adjacentRectangles: aCollection [

	self vertices: (OBlVerticesFromRectanglesOperator new verticesFromRectangles: aCollection)
]

{ #category : #initialization }
AlbSubtextElement >> computedAdjacentRectangles [

	^ self subclassResponsibility 
]

{ #category : #accessing }
AlbSubtextElement >> editorElement [

	^ editorElement
]

{ #category : #accessing }
AlbSubtextElement >> editorElement: anEditorElement [

	editorElement := anEditorElement.

]

{ #category : #initialization }
AlbSubtextElement >> initialize [ 

	super initialize.
	self vertices: #().


]

{ #category : #'api - install/uninstall  hook' }
AlbSubtextElement >> onInstalledIn: anEditorElement [

	self editorElement: anEditorElement.
	extentHandler := BlEventHandler on: BlElementExtentChangedEvent do: [ self updateVertices ].
	scrollHandler := BlEventHandler on: BlElementScrolledEvent do: [ :event | self updateVertices ].

	anEditorElement infinite addEventHandler: extentHandler.
	anEditorElement infinite addEventHandler: scrollHandler.

]

{ #category : #'api - install/uninstall  hook' }
AlbSubtextElement >> onUninstalledIn: anEditorElement [
	
	editorElement := nil.
	anEditorElement infinite removeEventHandler: extentHandler.
	anEditorElement infinite removeEventHandler: scrollHandler.

]

{ #category : #initialization }
AlbSubtextElement >> updateVertices [

	self subclassResponsibility 
]

{ #category : #accessing }
AlbSubtextElement >> vertices [

	^ self geometry vertices
]

{ #category : #accessing }
AlbSubtextElement >> vertices: aCollectionOfPoints [

	self geometry: (BlPolygonGeometry new vertices: aCollectionOfPoints).
]
