Class {
	#name : #AlbTextPortionElement,
	#superclass : #BlElement,
	#category : #'Album-UI'
}

{ #category : #'infinite element changes' }
AlbTextPortionElement >> adjacentRectangles: aCollection [

	self vertices: (OBlVerticesFromRectanglesOperator new verticesFromRectangles: aCollection)
]

{ #category : #accessing }
AlbTextPortionElement >> borderWidth [

	^ 1
]

{ #category : #accessing }
AlbTextPortionElement >> defaultBackground [ 

	^ Color transparent 
]

{ #category : #accessing }
AlbTextPortionElement >> defaultBorder [

	^ BlBorder paint: Color gray darker width: self borderWidth
]

{ #category : #initialization }
AlbTextPortionElement >> initialize [ 

	super initialize.
	self vertices: #().
	self geometry: BlPolygonGeometry new.
	self constraintsDo: [ :c | c ignoreByLayout  ].
	self outskirts: (BlOutskirts centered).


]

{ #category : #accessing }
AlbTextPortionElement >> vertices [

	^ self geometry vertices
]

{ #category : #accessing }
AlbTextPortionElement >> vertices: aCollectionOfPoints [

	aCollectionOfPoints ifEmpty: [ ^ self ].
	self geometry vertices: aCollectionOfPoints 
]
