Extension { #name : #AlbTextEditor }

{ #category : #'*Album-Brick-NU' }
AlbTextEditor >> beParagraphBased [
	segmentBuilder := AlbTextEditorLineSegmentBuilder new splitter: AlbTextEditorParagraphSplitter new
]
