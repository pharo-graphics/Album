Class {
	#name : #AlbEditorSelectionView,
	#superclass : #Object,
	#instVars : [
		'vertices',
		'borderWidth',
		'borderColor',
		'selectionColor'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbEditorSelectionView >> background [
	^ BlPaintBackground paint: self selectionColor
]

{ #category : #accessing }
AlbEditorSelectionView >> border [
	^ BlBorder paint: self borderColor width: self borderWidth 
]

{ #category : #accessing }
AlbEditorSelectionView >> borderColor [
	^ borderColor 
]

{ #category : #accessing }
AlbEditorSelectionView >> borderColor: aColor [
	borderColor := aColor
]

{ #category : #accessing }
AlbEditorSelectionView >> borderWidth [
	^ borderWidth 
]

{ #category : #accessing }
AlbEditorSelectionView >> borderWidth: aNumber [
	borderWidth := aNumber
]

{ #category : #accessing }
AlbEditorSelectionView >> geometry [
	^ BlPolygonGeometry vertices: vertices.
]

{ #category : #accessing }
AlbEditorSelectionView >> selectionColor [
	^ selectionColor
]

{ #category : #accessing }
AlbEditorSelectionView >> selectionColor: aColor [
	selectionColor := aColor
]

{ #category : #'infinite element changes' }
AlbEditorSelectionView >> selectionScrolled: aPoint in: anInfiniteElement [
	vertices ifNil: [ ^self ].
	vertices := vertices collect: [ :pt | pt - aPoint ]
]

{ #category : #accessing }
AlbEditorSelectionView >> vertices: aListOfPoints [
	vertices := aListOfPoints
]
