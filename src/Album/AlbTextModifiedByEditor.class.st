Class {
	#name : #AlbTextModifiedByEditor,
	#superclass : #Announcement,
	#instVars : [
		'text'
	],
	#category : #'Album-Model-Announcements'
}

{ #category : #accessing }
AlbTextModifiedByEditor >> text [

	^ text
]

{ #category : #accessing }
AlbTextModifiedByEditor >> text: aText [

	text := aText
]
