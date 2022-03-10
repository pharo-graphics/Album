Class {
	#name : #AblTextEditorRecordDeselectionSignal,
	#superclass : #Announcement,
	#instVars : [
		'selection'
	],
	#category : #'Album-Model-Selection'
}

{ #category : #printing }
AblTextEditorRecordDeselectionSignal >> printOneLineContentsOn: stream [
	self selection printOn: stream 
]

{ #category : #accessing }
AblTextEditorRecordDeselectionSignal >> selection [
	^ selection
]

{ #category : #accessing }
AblTextEditorRecordDeselectionSignal >> selection: anObject [
	selection := anObject
]
