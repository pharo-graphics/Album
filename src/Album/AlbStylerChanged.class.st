Class {
	#name : #AlbStylerChanged,
	#superclass : #Announcement,
	#instVars : [
		'styler'
	],
	#category : #'Album-Model-Announcements'
}

{ #category : #accessing }
AlbStylerChanged >> styler [
	^ styler
]

{ #category : #accessing }
AlbStylerChanged >> styler: anObject [
	styler := anObject
]
