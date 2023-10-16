Class {
	#name : 'AlbTextEditorCursorRemovedHolderEvent',
	#superclass : 'AlbTextEditorHolderEvent',
	#category : 'Album-Commands-Holder',
	#package : 'Album',
	#tag : 'Commands-Holder'
}

{ #category : 'sending' }
AlbTextEditorCursorRemovedHolderEvent >> sendTo: aSegmentHolder [
	aSegmentHolder onCursorRemoved
]
