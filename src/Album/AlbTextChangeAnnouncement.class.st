Class {
	#name : #AlbTextChangeAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'text'
	],
	#category : #'Album-Model-Announcements'
}

{ #category : #accessing }
AlbTextChangeAnnouncement >> text [

	^ text
]

{ #category : #accessing }
AlbTextChangeAnnouncement >> text: aText [

	text := aText
]
