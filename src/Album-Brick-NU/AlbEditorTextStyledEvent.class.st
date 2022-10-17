Class {
	#name : #AlbEditorTextStyledEvent,
	#superclass : #AlbEditorChangedEvent,
	#instVars : [
		'text'
	],
	#category : #'Album-Brick-NU-Album-Model-Events'
}

{ #category : #accessing }
AlbEditorTextStyledEvent class >> text: aText [
	^ self new text: aText
]

{ #category : #accessing }
AlbEditorTextStyledEvent >> text [

	^ text
]

{ #category : #accessing }
AlbEditorTextStyledEvent >> text: aBlText [

	text := aBlText 
]
