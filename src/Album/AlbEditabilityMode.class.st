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

{ #category : #initialization }
AlbEditabilityMode >> defaultRemanentSubtextEventHandlers [

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

{ #category : #testing }
AlbEditabilityMode >> ifEditableDo: aBlock [

	self isEditable ifFalse: [ ^ self ].
	aBlock value
]

{ #category : #testing }
AlbEditabilityMode >> ifWithPrimarySelectionDo: aBlock [

	self ifWithPrimarySelectionDo: aBlock ifNot: [  ]
]

{ #category : #testing }
AlbEditabilityMode >> ifWithPrimarySelectionDo: aBlock ifNot: aNoteBlock [

	self isWithPrimarySelection ifFalse: [
		aNoteBlock value.
		^ self ].
	aBlock value
]

{ #category : #testing }
AlbEditabilityMode >> isEditable [

	^ false
]

{ #category : #testing }
AlbEditabilityMode >> isWithPrimarySelection [

	^ true
]
