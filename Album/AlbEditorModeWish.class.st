Class {
	#name : #AlbEditorModeWish,
	#superclass : #AlbEditorWish,
	#instVars : [
		'mode'
	],
	#category : #'Album-Editor - Events'
}

{ #category : #'instance creation' }
AlbEditorModeWish class >> editable [
	^ self new mode: AlbTextEditorEditableMode new
]

{ #category : #'instance creation' }
AlbEditorModeWish class >> mode: aTextEditorMode [
	^ self new mode: aTextEditorMode
]

{ #category : #'instance creation' }
AlbEditorModeWish class >> readOnlyWithSelection [
	^ self new mode: AlbTextEditorReadonlyWithSelectionMode new
]

{ #category : #'instance creation' }
AlbEditorModeWish class >> readOnlyWithoutSelection [
	^ self new mode: AlbTextEditorReadonlyWithoutSelectionMode new
]

{ #category : #accessing }
AlbEditorModeWish >> mode [
	^ mode
]

{ #category : #accessing }
AlbEditorModeWish >> mode: anObject [
	mode := anObject
]
