Class {
	#name : #AlbEditabilityMode,
	#superclass : #Object,
	#category : #'Album-UI'
}

{ #category : #initialization }
AlbEditabilityMode >> defaultEditorElementEventHandlers [

	^ self subclassResponsibility 
]

{ #category : #initialization }
AlbEditabilityMode >> defaultSelectionView [

	^ AlbEditorSelectionView new
]

{ #category : #'shortcut management' }
AlbEditabilityMode >> defaultShortcuts [

	^ self subclassResponsibility 
]

{ #category : #initialization }
AlbEditabilityMode >> defaultWordStencil [ 

	^ AlbTextWordPieceStencil readOnly
]
