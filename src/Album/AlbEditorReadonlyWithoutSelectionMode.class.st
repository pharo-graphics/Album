Class {
	#name : #AlbEditorReadonlyWithoutSelectionMode,
	#superclass : #AlbEditorEditabilityMode,
	#category : #'Album-Model'
}

{ #category : #testing }
AlbEditorReadonlyWithoutSelectionMode >> allowSelection [

	^ false
]

{ #category : #testing }
AlbEditorReadonlyWithoutSelectionMode >> isEditable [

	^ false
]

{ #category : #'shortcut management' }
AlbEditorReadonlyWithoutSelectionMode >> shortcuts [

	^ {  }
]
