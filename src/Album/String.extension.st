Extension { #name : #String }

{ #category : #'*Album' }
String >> onAlbum [
	^ AlbEditor new text: self 
]
