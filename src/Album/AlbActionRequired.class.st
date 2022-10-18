Class {
	#name : #AlbActionRequired,
	#superclass : #Announcement,
	#instVars : [
		'valuable'
	],
	#category : #'Album-Model-Announcements'
}

{ #category : #accessing }
AlbActionRequired >> valuable: aValuable [

	valuable := aValuable
]

{ #category : #accessing }
AlbActionRequired >> value: anEditorElement [

	^ valuable value: anEditorElement
]
