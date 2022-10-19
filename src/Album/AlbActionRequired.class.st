Class {
	#name : #AlbActionRequired,
	#superclass : #Announcement,
	#instVars : [
		'valuable'
	],
	#category : #'Album-Announcements'
}

{ #category : #accessing }
AlbActionRequired >> valuable: aValuable [

	valuable := aValuable
]

{ #category : #accessing }
AlbActionRequired >> value: anObject [

	^ valuable value: anObject
]
