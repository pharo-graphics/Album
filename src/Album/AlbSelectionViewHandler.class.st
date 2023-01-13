Class {
	#name : #AlbSelectionViewHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'selectionView'
	],
	#category : #'Album-UI-Handlers'
}

{ #category : #accessing }
AlbSelectionViewHandler >> selectionView [

	^ selectionView
]

{ #category : #accessing }
AlbSelectionViewHandler >> selectionView: aSelectionView [

	selectionView := aSelectionView
]
