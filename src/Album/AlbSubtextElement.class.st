Class {
	#name : #AlbSubtextElement,
	#superclass : #AlbTextDecorationElement,
	#category : #'Album-UI'
}

{ #category : #'infinite element changes' }
AlbSubtextElement >> adjacentRectangles: aCollection [

	self vertices: (OBlVerticesFromRectanglesOperator new verticesFromRectangles: aCollection)
]

{ #category : #initialization }
AlbSubtextElement >> initialize [ 

	super initialize.
	self vertices: #().
	self geometry: BlPolygonGeometry new.

]

{ #category : #accessing }
AlbSubtextElement >> vertices [

	^ self geometry vertices
]

{ #category : #accessing }
AlbSubtextElement >> vertices: aCollectionOfPoints [

	aCollectionOfPoints ifEmpty: [ ^ self ].
	self geometry vertices: aCollectionOfPoints 
]
