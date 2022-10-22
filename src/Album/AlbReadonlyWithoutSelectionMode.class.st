Class {
	#name : #AlbReadonlyWithoutSelectionMode,
	#superclass : #AlbEditabilityMode,
	#category : #'Album-Model'
}

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
