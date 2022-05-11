Class {
	#name : #AlbTextEditorRecordSelectionSignal,
	#superclass : #Announcement,
	#instVars : [
		'selection'
	],
	#category : #'Album-Model-Selection'
}

{ #category : #printing }
AlbTextEditorRecordSelectionSignal >> printOneLineContentsOn: stream [
	self selection printOn: stream 
]

{ #category : #accessing }
AlbTextEditorRecordSelectionSignal >> selection [
	^ selection
]

{ #category : #accessing }
AlbTextEditorRecordSelectionSignal >> selection: anObject [
	selection := anObject
]
