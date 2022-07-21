Extension { #name : #SkiaFont }

{ #category : #'*Album-Sparta' }
SkiaFont >> averageWidthOf: aCharacter [
	^ self metrics averageCharWidth//2.5
]
