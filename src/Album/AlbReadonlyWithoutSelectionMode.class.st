Class {
	#name : #AlbReadonlyWithoutSelectionMode,
	#superclass : #AlbEditabilityMode,
	#category : #'Album-UI'
}

{ #category : #initialization }
AlbReadonlyWithoutSelectionMode >> defaultEditorElementEventHandlers [

	^ {  }
]

{ #category : #initialization }
AlbReadonlyWithoutSelectionMode >> defaultFrontLayerEventHandlers [

	^ {  }
]

{ #category : #initialization }
AlbReadonlyWithoutSelectionMode >> defaultRemanentSubtextEventHandlers [

	^ {  }
]

{ #category : #initialization }
AlbReadonlyWithoutSelectionMode >> defaultSelectionView [

	^ nil

]

{ #category : #'shortcut management' }
AlbReadonlyWithoutSelectionMode >> defaultShortcuts [

	^ {  }
]

{ #category : #testing }
AlbReadonlyWithoutSelectionMode >> isWithPrimarySelection [

	^ false
]
