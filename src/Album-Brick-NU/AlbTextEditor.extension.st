Extension { #name : #AlbTextEditor }

{ #category : #'*Album-Brick-NU' }
AlbTextEditor >> beParagraphBased [
	self segmentBuilder: (AlbTextEditorLineSegmentBuilder new splitter: AlbTextEditorParagraphSplitter new)
]
