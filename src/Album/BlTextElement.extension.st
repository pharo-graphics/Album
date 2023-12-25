Extension { #name : #BlTextElement }

{ #category : #'*Album' }
BlTextElement >> positionInEditor [
	^ self constraints albumTextFlow positionInEditor
]

{ #category : #'*Album' }
BlTextElement >> positionInEditor: aPoint [
	self constraints albumTextFlow positionInEditor: aPoint
]
