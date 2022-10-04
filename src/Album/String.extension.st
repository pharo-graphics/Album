Extension { #name : #String }

{ #category : #'*Album' }
String >> onAlbum [
	^ AlbEditorElement new text: self 
]
