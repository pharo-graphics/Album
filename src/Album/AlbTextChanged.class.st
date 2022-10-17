Class {
	#name : #AlbTextChanged,
	#superclass : #Announcement,
	#instVars : [
		'text'
	],
	#category : #'Album-Model-Announcements'
}

{ #category : #accessing }
AlbTextChanged >> text [

	^ text
]

{ #category : #accessing }
AlbTextChanged >> text: anObject [

	text := anObject
]
