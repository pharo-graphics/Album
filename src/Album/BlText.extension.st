Extension { #name : #BlText }

{ #category : #'*Album' }
BlText >> onAlbum [
	^ AlbEditor new text: self 
]
