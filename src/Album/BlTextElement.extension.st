Extension { #name : #BlTextElement }

{ #category : #'*Album' }
BlTextElement >> positionInEditor: aPoint [
	self constraints albumTextFlow positionInEditor: aPoint
]
