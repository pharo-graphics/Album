Extension { #name : #BlText }

{ #category : #'*Album' }
BlText >> onAlbum [
	^ AlbEditorElement new text: self 
]
