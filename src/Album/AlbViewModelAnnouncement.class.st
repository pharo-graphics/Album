Class {
	#name : #AlbViewModelAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'viewModel'
	],
	#category : #'Album-Model-Announcements'
}

{ #category : #accessing }
AlbViewModelAnnouncement >> viewModel [ 

	^ viewModel
]

{ #category : #accessing }
AlbViewModelAnnouncement >> viewModel: aViewModel [

	viewModel := aViewModel
]
