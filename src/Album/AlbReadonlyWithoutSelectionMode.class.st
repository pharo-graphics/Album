Class {
	#name : #AlbReadonlyWithoutSelectionMode,
	#superclass : #AlbEditabilityMode,
	#category : #'Album-Model'
}

{ #category : #testing }
AlbReadonlyWithoutSelectionMode >> allowSelection [

	^ false
]

{ #category : #testing }
AlbReadonlyWithoutSelectionMode >> isEditable [

	^ false
]

{ #category : #'shortcut management' }
AlbReadonlyWithoutSelectionMode >> shortcuts [

	^ {  }
]
