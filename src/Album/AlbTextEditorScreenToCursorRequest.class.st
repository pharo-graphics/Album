Class {
	#name : 'AlbTextEditorScreenToCursorRequest',
	#superclass : 'AlbTextEditorRequest',
	#instVars : [
		'transformation'
	],
	#category : 'Album-UI-Requests',
	#package : 'Album',
	#tag : 'UI-Requests'
}

{ #category : 'accessing' }
AlbTextEditorScreenToCursorRequest >> transformation [
	^ transformation
]

{ #category : 'accessing' }
AlbTextEditorScreenToCursorRequest >> transformation: anObject [
	transformation := anObject
]
