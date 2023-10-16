Class {
	#name : 'AlbTextEditorTextChangedRequest',
	#superclass : 'AlbTextEditorRequest',
	#instVars : [
		'segmentPiece',
		'text',
		'textStart',
		'textEnd'
	],
	#category : 'Album-UI-Requests',
	#package : 'Album',
	#tag : 'UI-Requests'
}

{ #category : 'accessing' }
AlbTextEditorTextChangedRequest >> segmentPiece [
	^ segmentPiece
]

{ #category : 'accessing' }
AlbTextEditorTextChangedRequest >> segmentPiece: anObject [
	segmentPiece := anObject
]

{ #category : 'accessing' }
AlbTextEditorTextChangedRequest >> text [
	^ text
]

{ #category : 'accessing' }
AlbTextEditorTextChangedRequest >> text: anObject [
	text := anObject
]

{ #category : 'accessing' }
AlbTextEditorTextChangedRequest >> textEnd [
	^ textEnd
]

{ #category : 'accessing' }
AlbTextEditorTextChangedRequest >> textEnd: anObject [
	textEnd := anObject
]

{ #category : 'accessing' }
AlbTextEditorTextChangedRequest >> textStart [
	^ textStart
]

{ #category : 'accessing' }
AlbTextEditorTextChangedRequest >> textStart: anObject [
	textStart := anObject
]
