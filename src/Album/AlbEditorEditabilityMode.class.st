Class {
	#name : #AlbEditorEditabilityMode,
	#superclass : #Object,
	#category : #'Album-Model'
}

{ #category : #testing }
AlbEditorEditabilityMode >> allowSelection [

	^ self subclassResponsibility 
]

{ #category : #testing }
AlbEditorEditabilityMode >> forbidSelection [

	^ self allowSelection not
]

{ #category : #testing }
AlbEditorEditabilityMode >> isEditable [

	^self subclassResponsibility 
]

{ #category : #testing }
AlbEditorEditabilityMode >> isReadOnly [

	^ self isEditable not
]

{ #category : #'shortcut management' }
AlbEditorEditabilityMode >> shortcuts [

	^self subclassResponsibility 
]
