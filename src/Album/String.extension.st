Extension { #name : #String }

{ #category : #'*Album' }
String >> onAlbTextEditor [
	^ AlbEditor new text: self 
]
