Class {
	#name : #AlbEditorStylerChanged,
	#superclass : #AlbEditorChangedEvent,
	#instVars : [
		'styler'
	],
	#category : #'Album-Editor - Events'
}

{ #category : #accessing }
AlbEditorStylerChanged class >> styler: aStyler [
	^ self new styler: aStyler
]

{ #category : #accessing }
AlbEditorStylerChanged >> styler [
	^ styler
]

{ #category : #accessing }
AlbEditorStylerChanged >> styler: anObject [
	styler := anObject
]
