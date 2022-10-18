Class {
	#name : #AlbEditorWithSaveTransactionModel,
	#superclass : #AlbEditorModel,
	#instVars : [
		'hasUnacceptedEdits'
	],
	#category : #'Album-Model'
}

{ #category : #initialization }
AlbEditorWithSaveTransactionModel >> defaultShortcuts [

	^ super defaultShortcuts , { AlbEditorSaveShortcut new }
]

{ #category : #accessing }
AlbEditorWithSaveTransactionModel >> hasUnacceptedEdits [

	^ hasUnacceptedEdits ifNil: [ hasUnacceptedEdits := false ]
]

{ #category : #accessing }
AlbEditorWithSaveTransactionModel >> hasUnacceptedEdits: aBoolean [

	hasUnacceptedEdits = aBoolean ifTrue: [ ^ self ].
	hasUnacceptedEdits := aBoolean.
	self announce: (AlbEditsStateChangedInModel new viewModel: self)
]

{ #category : #'api-transaction' }
AlbEditorWithSaveTransactionModel >> requestSave [

	self announce: (AlbSaveRequested new viewModel: self).
	self saveResult: true
]

{ #category : #'api-transaction' }
AlbEditorWithSaveTransactionModel >> saveResult: aBoolean [

	| announcement |
	self hasUnacceptedEdits: aBoolean not.
	announcement := aBoolean
		                ifTrue: [ AlbSaveAccepted new ]
		                ifFalse: [ AlbSaveDenied new ].
	self announce: (announcement viewModel: self).

]

{ #category : #'api - hooks' }
AlbEditorWithSaveTransactionModel >> textModifiedByTextEditor [

	super textModifiedByTextEditor.
	self hasUnacceptedEdits: true
]
