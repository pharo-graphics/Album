Class {
	#name : #AlbAbstractSubtextElement,
	#superclass : #AlbTextPortionElement,
	#instVars : [
		'editorElement'
	],
	#category : #'Album-UI-Text-Portion'
}

{ #category : #'instance creation' }
AlbAbstractSubtextElement class >> editorElement: anEditorElement [

	^ (self basicNew editorElement: anEditorElement)
		  initialize;
		  yourself
]

{ #category : #initialization }
AlbAbstractSubtextElement >> defaultGeometry [

	^ BlPolygonGeometry new
]

{ #category : #accessing }
AlbAbstractSubtextElement >> editorElement [

	^ editorElement
]

{ #category : #accessing }
AlbAbstractSubtextElement >> editorElement: anEditorElement [

	editorElement := anEditorElement
]

{ #category : #initialization }
AlbAbstractSubtextElement >> initialize [ 

	super initialize.
	self geometry: self defaultGeometry.
	self vertices: #()
]

{ #category : #initialization }
AlbAbstractSubtextElement >> updateVertices [

	self subclassResponsibility 
]

{ #category : #accessing }
AlbAbstractSubtextElement >> vertices [

	^ self geometry vertices
]

{ #category : #accessing }
AlbAbstractSubtextElement >> vertices: aCollectionOfPoints [

	self geometry: (self defaultGeometry vertices: aCollectionOfPoints).
	self notifyPositionChanged
]
