Class {
	#name : #AlbEditorTextStyledEvent,
	#superclass : #AlbEditorChangedEvent,
	#instVars : [
		'text'
	],
	#category : #'Album-Model-Events'
}

{ #category : #accessing }
AlbEditorTextStyledEvent class >> text: aText [
	^ self new text: aText
]

{ #category : #sending }
AlbEditorTextStyledEvent >> sendTo: anEventHandler [

	anEventHandler textStyledEvent: self
]

{ #category : #accessing }
AlbEditorTextStyledEvent >> text [

	^ text
]

{ #category : #accessing }
AlbEditorTextStyledEvent >> text: aBlText [

	text := aBlText 
]
