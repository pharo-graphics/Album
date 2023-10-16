Extension { #name : 'TBlDevScripterTarget' }

{ #category : '*Album' }
TBlDevScripterTarget >> onAlbTextEditorText [
	self onChildFromMessage: #text
]

{ #category : '*Album' }
TBlDevScripterTarget >> onAlbum [
	^ self onChildFromMessage: #editor
]
