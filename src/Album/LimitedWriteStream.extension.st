Extension { #name : #LimitedWriteStream }

{ #category : #'*Album' }
LimitedWriteStream >> segments [
	^ self contents
]

{ #category : #'*Album' }
LimitedWriteStream >> unlimited [
	self limit: Float infinity 
]

{ #category : #'*Album' }
LimitedWriteStream >> wantsMore [
	^ self size < self limit
]
