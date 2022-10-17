Class {
	#name : #AlbTextStyleDone,
	#superclass : #Announcement,
	#instVars : [
		'styledText'
	],
	#category : #'Album-Model-Announcements'
}

{ #category : #accessing }
AlbTextStyleDone >> styledText [
	^ styledText
]

{ #category : #accessing }
AlbTextStyleDone >> styledText: anObject [
	styledText := anObject
]
