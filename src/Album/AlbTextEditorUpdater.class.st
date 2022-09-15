Class {
	#name : #AlbTextEditorUpdater,
	#superclass : #AlbTextEditorOperator,
	#instVars : [
		'intervals',
		'shouldRedraw',
		'shouldRecreate'
	],
	#category : #'Album-Model-Operators'
}

{ #category : #'api - configuration' }
AlbTextEditorUpdater >> all [
	self from: 1 to: self text size
]

{ #category : #'api - processing' }
AlbTextEditorUpdater >> apply [
	^ self update 
]

{ #category : #'api - configuration' }
AlbTextEditorUpdater >> from: aFromTextIndex to: aToTextIndex [
	"Both from and to indices must be given in text coordinates"

	intervals add: (aFromTextIndex to: aToTextIndex)
]

{ #category : #initialization }
AlbTextEditorUpdater >> initialize [
	super initialize.
	
	intervals := OrderedCollection new.
	shouldRecreate := true.
	shouldRedraw := true
]

{ #category : #'api - configuration' }
AlbTextEditorUpdater >> redrawOnly [
	shouldRedraw := true.
	shouldRecreate := false
]

{ #category : #'api - processing' }
AlbTextEditorUpdater >> update [
	intervals do: [ :eachInterval |
		(shouldRecreate not and: [ shouldRedraw ])
			ifTrue: [
				| aCommand |
				aCommand := AlbTextEditorInvalidateCommand new
					fromIndex: eachInterval first;
					toIndex: eachInterval last.
				editor executeCommand: aCommand ].
		shouldRecreate
			ifTrue: [
				| aCommand |
				aCommand := AlbTextEditorUpdateCommand new
					fromIndex: eachInterval first;
					toIndex: eachInterval last.
				editor executeCommand: aCommand ] ]
]
