Class {
	#name : #AlbEditorTextChanged,
	#superclass : #Announcement,
	#instVars : [
		'text'
	],
	#category : #'Album-Model-Announcements'
}

{ #category : #accessing }
AlbEditorTextChanged >> text [

	^ text
]

{ #category : #accessing }
AlbEditorTextChanged >> text: anObject [

	text := anObject
]
