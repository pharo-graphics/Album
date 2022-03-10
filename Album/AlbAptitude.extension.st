Extension { #name : #AlbAptitude }

{ #category : #'*Album-Theme' }
AlbAptitude >> theme [
	^ widget ifNil: [ AlbTheme default ] ifNotNil: #theme
]
