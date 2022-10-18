Class {
	#name : #AlbEditabilityMode,
	#superclass : #Object,
	#category : #'Album-Model'
}

{ #category : #testing }
AlbEditabilityMode >> allowSelection [

	^ self subclassResponsibility 
]

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

{ #category : #testing }
AlbEditabilityMode >> forbidSelection [

	^ self allowSelection not
]

{ #category : #testing }
AlbEditabilityMode >> isEditable [

	^self subclassResponsibility 
]

{ #category : #testing }
AlbEditabilityMode >> isReadOnly [

	^ self isEditable not
]
