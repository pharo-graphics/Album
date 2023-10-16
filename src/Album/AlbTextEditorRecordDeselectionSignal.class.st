Class {
	#name : 'AlbTextEditorRecordDeselectionSignal',
	#superclass : 'Announcement',
	#instVars : [
		'selection'
	],
	#category : 'Album-Model-Selection',
	#package : 'Album',
	#tag : 'Model-Selection'
}

{ #category : 'printing' }
AlbTextEditorRecordDeselectionSignal >> printOneLineContentsOn: stream [
	self selection printOn: stream 
]

{ #category : 'accessing' }
AlbTextEditorRecordDeselectionSignal >> selection [
	^ selection
]

{ #category : 'accessing' }
AlbTextEditorRecordDeselectionSignal >> selection: anObject [
	selection := anObject
]
