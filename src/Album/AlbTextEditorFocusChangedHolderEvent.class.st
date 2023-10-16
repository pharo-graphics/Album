"
I trigger a focus state update in the text piece
"
Class {
	#name : 'AlbTextEditorFocusChangedHolderEvent',
	#superclass : 'AlbTextEditorHolderEvent',
	#instVars : [
		'hasFocus'
	],
	#category : 'Album-Commands-Holder',
	#package : 'Album',
	#tag : 'Commands-Holder'
}

{ #category : 'accessing' }
AlbTextEditorFocusChangedHolderEvent >> hasFocus [
	^ hasFocus
]

{ #category : 'accessing' }
AlbTextEditorFocusChangedHolderEvent >> hasFocus: aBoolean [
	hasFocus := aBoolean
]

{ #category : 'sending' }
AlbTextEditorFocusChangedHolderEvent >> sendTo: aSegmentHolder [
	aSegmentHolder onFocusChanged: self hasFocus
]
