Class {
	#name : #AlbEditorModeState,
	#superclass : #BlElementState,
	#instVars : [
		'mode'
	],
	#category : #'Album-Editor-Model'
}

{ #category : #'instance creation' }
AlbEditorModeState class >> editable [
	^ self new mode: AlbTextEditorEditableMode
]

{ #category : #'instance creation' }
AlbEditorModeState class >> mode: aTextEditorModeClass [
	^ self new mode: aTextEditorModeClass
]

{ #category : #'instance creation' }
AlbEditorModeState class >> readOnly [
	^ self readOnlyWithSelection or: self readOnlyWithoutSelection
]

{ #category : #'instance creation' }
AlbEditorModeState class >> readOnlyWithSelection [
	^ self new mode: AlbTextEditorReadonlyWithSelectionMode 
]

{ #category : #'instance creation' }
AlbEditorModeState class >> readOnlyWithoutSelection [
	^ self new mode: AlbTextEditorReadonlyWithoutSelectionMode
]

{ #category : #comparing }
AlbEditorModeState >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ mode = anObject mode
]

{ #category : #comparing }
AlbEditorModeState >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ mode hash
]

{ #category : #accessing }
AlbEditorModeState >> mode [
	<return: #Class>

	^ mode
]

{ #category : #accessing }
AlbEditorModeState >> mode: aModeClass [
	mode := aModeClass
]

{ #category : #accessing }
AlbEditorModeState >> priority [
	^ UserPriority
]

{ #category : #accessing }
AlbEditorModeState >> type [
	"Return an object used to compare two states when adding to the collection of states in order to prevent
	elements from having duplicated states"
	<return: #Object>

	^ self class
]
