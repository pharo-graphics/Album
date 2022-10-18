Class {
	#name : #AlbReadonlyWithoutSelectionMode,
	#superclass : #AlbEditabilityMode,
	#category : #'Album-Model'
}

{ #category : #testing }
AlbReadonlyWithoutSelectionMode >> allowSelection [

	^ false
]

{ #category : #initialization }
AlbReadonlyWithoutSelectionMode >> defaultEditorElementEventHandlers [

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
AlbReadonlyWithoutSelectionMode >> isEditable [

	^ false
]
