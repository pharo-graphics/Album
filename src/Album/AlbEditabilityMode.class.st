Class {
	#name : 'AlbEditabilityMode',
	#superclass : 'Object',
	#category : 'Album-UI',
	#package : 'Album',
	#tag : 'UI'
}

{ #category : 'initialization' }
AlbEditabilityMode >> defaultEditorElementEventHandlers [

	^ self subclassResponsibility 
]

{ #category : 'initialization' }
AlbEditabilityMode >> defaultFrontLayerEventHandlers [

	^ self subclassResponsibility 
]

{ #category : 'shortcut management' }
AlbEditabilityMode >> defaultShortcuts [

	^ self subclassResponsibility 
]

{ #category : 'initialization' }
AlbEditabilityMode >> defaultWordStencil [ 

	^ AlbTextWordPieceStencil readOnly
]

{ #category : 'testing' }
AlbEditabilityMode >> isEditable [

	^ false
]

{ #category : 'initialization' }
AlbEditabilityMode >> primarySelectionElementIn: anEditorElement [

	^ AlbPrimarySelectionElement editorElement: anEditorElement
]
