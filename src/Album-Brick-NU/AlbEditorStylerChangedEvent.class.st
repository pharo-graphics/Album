Class {
	#name : #AlbEditorStylerChangedEvent,
	#superclass : #AlbEditorChangedEvent,
	#instVars : [
		'styler'
	],
	#category : #'Album-Brick-NU-Album-Model-Events'
}

{ #category : #accessing }
AlbEditorStylerChangedEvent class >> styler: aStyler [
	^ self new styler: aStyler
]

{ #category : #sending }
AlbEditorStylerChangedEvent >> sendTo: anEventHandler [

	anEventHandler stylerChangedEvent: self
]

{ #category : #accessing }
AlbEditorStylerChangedEvent >> styler [
	^ styler
]

{ #category : #accessing }
AlbEditorStylerChangedEvent >> styler: anObject [
	styler := anObject
]
