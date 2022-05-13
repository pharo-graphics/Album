Extension { #name : #TBlDevScripterTarget }

{ #category : #'*Album' }
TBlDevScripterTarget >> onAlbTextEditor [
	self onChildFromMessage: #editor
]

{ #category : #'*Album' }
TBlDevScripterTarget >> onAlbTextEditorText [
	self onChildFromMessage: #text
]
