Class {
	#name : #AlbEditabilityMode,
	#superclass : #Object,
	#category : #'Album-Model'
}

{ #category : #initialization }
AlbEditabilityMode >> defaultEditorElementEventHandlers [

	^ self subclassResponsibility 
]

{ #category : #initialization }
AlbEditabilityMode >> defaultSelectionView [

	^ AlbEditorMainSelectionView new
]

{ #category : #'shortcut management' }
AlbEditabilityMode >> defaultShortcuts [

	^ self subclassResponsibility 
]

{ #category : #initialization }
AlbEditabilityMode >> defaultWordStencil [ 

	^ AlbTextWordPieceStencil readOnly
]
