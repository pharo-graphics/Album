Extension { #name : #SpartaCairoFreetypeFontFace }

{ #category : #'*Album-Sparta' }
SpartaCairoFreetypeFontFace >> averageWidthOf: aCharacter [
	^ self freetypeFont averageWidthOf: aCharacter
]
