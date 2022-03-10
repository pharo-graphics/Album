Extension { #name : #BlElement }

{ #category : #'*Album' }
BlElement >> layoutResizerPropagations [
	^ self userData
		at: #layoutResizerPropagations
		ifAbsentPut: [ AlbLayoutResizerElementPropagations new element: self ]
]

{ #category : #'*Album-Theme' }
BlElement >> theme [
	^ self userData
		at: #AlbTheme
		ifAbsent: [ self hasParent
				ifTrue: [ self parent theme ]
				ifFalse: [ AlbTheme default ] ]
]

{ #category : #'*Album-Theme' }
BlElement >> theme: aTheme [
	self userData at: #AlbTheme put: aTheme.
	self properties
		addProperty:
			(AlbThemeElementProperty new
				theme: aTheme;
				yourself)
]
