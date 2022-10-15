Class {
	#name : #AlbEditorWithCodeInteractionModel,
	#superclass : #AlbEditorModel,
	#instVars : [
		'interactionModel',
		'hasUnacceptedEdits'
	],
	#category : #'Album-Model'
}

{ #category : #binding }
AlbEditorWithCodeInteractionModel >> bindingOf: aString [ 
	^ interactionModel bindingOf: aString 
]

{ #category : #initialization }
AlbEditorWithCodeInteractionModel >> createShortcuts [

	^ super createShortcuts , { AlbEditorSaveShortcut new }
]

{ #category : #initialization }
AlbEditorWithCodeInteractionModel >> defaultInteractionModel [

	^ AlbCodeNullInteraction new
]

{ #category : #binding }
AlbEditorWithCodeInteractionModel >> doItContext [
	^ interactionModel doItContext
]

{ #category : #binding }
AlbEditorWithCodeInteractionModel >> doItReceiver [
	^ interactionModel doItReceiver
]

{ #category : #binding }
AlbEditorWithCodeInteractionModel >> hasBindingOf: aString [
	^ interactionModel hasBindingOf: aString
]

{ #category : #accessing }
AlbEditorWithCodeInteractionModel >> hasUnacceptedEdits [

	^ hasUnacceptedEdits ifNil: [ hasUnacceptedEdits := false ]
]

{ #category : #accessing }
AlbEditorWithCodeInteractionModel >> hasUnacceptedEdits: aBoolean [

	hasUnacceptedEdits = aBoolean ifTrue: [ ^ self ].
	hasUnacceptedEdits := aBoolean.
	self announce: (AlbEditsStateChangedInModel new viewModel: self)
]

{ #category : #initialization }
AlbEditorWithCodeInteractionModel >> initialize [

	super initialize.
	self interactionModel: self defaultInteractionModel
]

{ #category : #accessing }
AlbEditorWithCodeInteractionModel >> interactionModel [

	^ interactionModel
]

{ #category : #accessing }
AlbEditorWithCodeInteractionModel >> interactionModel: anObject [

	interactionModel ifNotNil: [ interactionModel onUninstalledIn: self ].
	interactionModel := anObject.
	interactionModel onInstalledIn: self
]

{ #category : #binding }
AlbEditorWithCodeInteractionModel >> isScripting [

	^ interactionModel isScripting
]

{ #category : #'api - hooks' }
AlbEditorWithCodeInteractionModel >> onInstalledIn: anElement [

	super onInstalledIn: anElement.
	self when: AlbSaveAccepted send: #whenSaveAcceptedFromModel: to: anElement.
	self when: AlbSaveDenied send: #whenSaveDeniedFromModel: to: anElement.


]

{ #category : #'api-transaction' }
AlbEditorWithCodeInteractionModel >> requestSave [

	self announce: (AlbSaveRequested new viewModel: self).
	self saveResult: true
]

{ #category : #'api-transaction' }
AlbEditorWithCodeInteractionModel >> saveResult: aBoolean [

	| announcement |
	self hasUnacceptedEdits: aBoolean not.
	announcement := aBoolean
		                ifTrue: [ AlbSaveAccepted new ]
		                ifFalse: [ AlbSaveDenied new ].
	self announce: (announcement viewModel: self).

]

{ #category : #binding }
AlbEditorWithCodeInteractionModel >> selectedClassOrMetaClass [

	^ interactionModel selectedClassOrMetaClass
]

{ #category : #'api - hooks' }
AlbEditorWithCodeInteractionModel >> textEdited [

	self hasUnacceptedEdits: true
]

{ #category : #binding }
AlbEditorWithCodeInteractionModel >> variableBindings [

	"Required for polymorphism with the Playground"

	^ interactionModel bindings
]
