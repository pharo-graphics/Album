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
AlbEditabilityMode >> defaultFrontLayerEventHandlers [

	^ self subclassResponsibility 
]

{ #category : #'shortcut management' }
AlbEditabilityMode >> defaultShortcuts [

	^ self subclassResponsibility 
]

{ #category : #initialization }
AlbEditabilityMode >> defaultWordStencil [ 

	^ AlbTextWordPieceStencil readOnly
]

{ #category : #initialization }
AlbEditabilityMode >> selectionElement [

	^ AlbSelectionElement new
]
