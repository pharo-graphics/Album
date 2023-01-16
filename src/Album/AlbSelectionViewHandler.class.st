Class {
	#name : #AlbSelectionViewHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'selectionView',
		'editorElement'
	],
	#category : #'Album-UI-Handlers'
}

{ #category : #accessing }
AlbSelectionViewHandler >> editorElement [

	^ editorElement
]

{ #category : #accessing }
AlbSelectionViewHandler >> editorElement: anEditorElement [

	editorElement := anEditorElement
]

{ #category : #accessing }
AlbSelectionViewHandler >> selectionView [

	^ selectionView
]

{ #category : #accessing }
AlbSelectionViewHandler >> selectionView: aSelectionView [

	selectionView := aSelectionView
]
