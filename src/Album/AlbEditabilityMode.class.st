Class {
	#name : #AlbEditabilityMode,
	#superclass : #Object,
	#category : #'Album-Model'
}

{ #category : #testing }
AlbEditabilityMode >> allowSelection [

	^ self subclassResponsibility 
]

{ #category : #testing }
AlbEditabilityMode >> forbidSelection [

	^ self allowSelection not
]

{ #category : #testing }
AlbEditabilityMode >> isEditable [

	^self subclassResponsibility 
]

{ #category : #testing }
AlbEditabilityMode >> isReadOnly [

	^ self isEditable not
]

{ #category : #'shortcut management' }
AlbEditabilityMode >> shortcuts [

	^self subclassResponsibility 
]
