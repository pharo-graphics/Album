Class {
	#name : #AblTextEditorRecordSelectionSignal,
	#superclass : #Announcement,
	#instVars : [
		'selection'
	],
	#category : #'Album-Editor-Model - Selection'
}

{ #category : #printing }
AblTextEditorRecordSelectionSignal >> printOneLineContentsOn: stream [
	self selection printOn: stream 
]

{ #category : #accessing }
AblTextEditorRecordSelectionSignal >> selection [
	^ selection
]

{ #category : #accessing }
AblTextEditorRecordSelectionSignal >> selection: anObject [
	selection := anObject
]
