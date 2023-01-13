Class {
	#name : #AlbEditorSelectionView,
	#superclass : #Object,
	#instVars : [
		'vertices',
		'borderWidth',
		'borderColor',
		'selectionColor',
		'selectionGeometry'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbEditorSelectionView >> backgroundIn: anInfiniteElement [

	^ BlPaintBackground paint: (anInfiniteElement hasFocus
			   ifTrue: [ selectionColor ]
			   ifFalse: [ Color veryLightGray alpha: 0.1 ])
]

{ #category : #accessing }
AlbEditorSelectionView >> borderColor: aColor [
	borderColor := aColor
]

{ #category : #accessing }
AlbEditorSelectionView >> borderColorIn: anInfiniteElement [

	^ anInfiniteElement hasFocus
		  ifTrue: [ borderColor ]
		  ifFalse: [ Color veryLightGray ]
]

{ #category : #accessing }
AlbEditorSelectionView >> borderIn: anInfiniteElement [

	^ BlBorder
		  paint: (self borderColorIn: anInfiniteElement)
		  width: self borderWidth
]

{ #category : #accessing }
AlbEditorSelectionView >> borderWidth [

	^ borderWidth
]

{ #category : #accessing }
AlbEditorSelectionView >> borderWidth: aNumber [

	borderWidth := aNumber
]

{ #category : #initialization }
AlbEditorSelectionView >> initialize [ 

	super initialize.
	vertices := #()
]

{ #category : #accessing }
AlbEditorSelectionView >> newSelectionGeometry [ 

	self vertices ifEmpty: [ ^ nil ].
	^ BlPolygonGeometry new vertices: self vertices


]

{ #category : #accessing }
AlbEditorSelectionView >> selectionColor [

	^ selectionColor
]

{ #category : #accessing }
AlbEditorSelectionView >> selectionColor: aColor [

	selectionColor := aColor
]

{ #category : #accessing }
AlbEditorSelectionView >> selectionGeometry [

	^ selectionGeometry 
]

{ #category : #'infinite element changes' }
AlbEditorSelectionView >> selectionScrolled: aPoint in: anInfiniteElement [

	vertices ifEmpty: [ ^ self ].
	vertices := vertices collect: [ :pt | pt - aPoint ]
]

{ #category : #accessing }
AlbEditorSelectionView >> vertices [

	^ vertices 
]

{ #category : #accessing }
AlbEditorSelectionView >> vertices: aListOfPoints [

	vertices := aListOfPoints.
	selectionGeometry := self newSelectionGeometry
]
