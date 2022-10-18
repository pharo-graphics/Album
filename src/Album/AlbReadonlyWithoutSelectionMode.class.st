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
AlbReadonlyWithoutSelectionMode >> defaultSelectionView [

	^ nil

]

{ #category : #initialization }
AlbReadonlyWithoutSelectionMode >> editorElementEventHandlers [

	^ {  }
]

{ #category : #testing }
AlbReadonlyWithoutSelectionMode >> isEditable [

	^ false
]

{ #category : #'shortcut management' }
AlbReadonlyWithoutSelectionMode >> shortcuts [

	^ {  }
]
