Class {
	#name : #AlbEditorStylerChanged,
	#superclass : #Announcement,
	#instVars : [
		'styler'
	],
	#category : #'Album-Model-Announcements'
}

{ #category : #accessing }
AlbEditorStylerChanged >> styler [
	^ styler
]

{ #category : #accessing }
AlbEditorStylerChanged >> styler: anObject [
	styler := anObject
]
