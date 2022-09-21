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
AlbEditorSelectionView >> vertices: aListOfPoints [
	vertices := aListOfPoints
]
