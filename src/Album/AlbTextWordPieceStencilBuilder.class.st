Class {
	#name : #AlbTextWordPieceStencilBuilder,
	#superclass : #OBlStencilBuilder,
	#instVars : [
		'wordPadding',
		'wordMargin',
		'segmentPiece',
		'readOnly'
	],
	#category : #'Album-UI-Stencils'
}

{ #category : #'instance creation' }
AlbTextWordPieceStencilBuilder class >> editable [
	^ self new beEditable 
]

{ #category : #'instance creation' }
AlbTextWordPieceStencilBuilder class >> readOnly [
	^ self new beReadOnly 
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencilBuilder >> allEventHandlers [
	readOnly ifTrue: [ ^ self readOnlyWordPieceEventHandlers ].
	^ self editableWordPieceEventHandlers 
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencilBuilder >> beEditable [

	readOnly := false
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencilBuilder >> beReadOnly [ 

	readOnly := true
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencilBuilder >> buildDefault [

	| aTextElement |
	aTextElement := self createWordElement
		                segmentPiece: self segmentPiece;
		                padding: self wordPadding;
		                margin: self wordMargin.

	self reset.

	^ aTextElement
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencilBuilder >> createWordElement [
	<return: #AlbTextElements>
	| wordElement |
	wordElement := AlbTextElement new.
	wordElement editorMeasurement.
	self allEventHandlers do: [ :e |
		wordElement addEventHandler: e ].
	^ wordElement
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencilBuilder >> editableWordPieceEventHandlers [

	^ {  "to support event-handling attributes"
			AlbTextEditorLineSegmentTextListener uniqueInstance.
			
		  "editor requests to show a cursor as a result of its position change"
		  AlbTextWordPieceShowCursorHandler uniqueInstance.

		  "editor requests to remove a cursor as a result of its position change"
		  AlbTextWordPieceHideCursorHandler uniqueInstance.
			
			"for screen position to cursor index transformation"
			AlbTextWordPieceScreenToCursorHandler uniqueInstance.

			AlbTextWordPieceFocusHandler uniqueInstance.
			AlbTextWordPieceBlurHandler uniqueInstance.
			
			"selection changed in the editor, select a given interval"
			AlbTextWordPieceSelectionHandler uniqueInstance.
			
			"selection changed in the editor, deselect a given interval"
			AlbTextWordPieceDeselectionHandler uniqueInstance.
			
			"text changed in the editor"
			AlbTextWordPieceTextChangeHandler uniqueInstance.	

			"text piece got inside of selected area"
			AlbTextWordPieceSelectionAcquiredHandler uniqueInstance.

			"text piece got outside of then selected area"
			AlbTextWordPieceSelectionLostHandler uniqueInstance. }

	
]

{ #category : #initialization }
AlbTextWordPieceStencilBuilder >> initialize [
	super initialize.
	readOnly := false.
	
	self reset
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencilBuilder >> paramsOn: aStencilExecutor [
	aStencilExecutor push: self segmentPiece
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencilBuilder >> readOnlyWordPieceEventHandlers [

	^ {  "to support event-handling attributes"
			AlbTextEditorLineSegmentTextListener uniqueInstance.
			
			"for screen position to cursor index transformation"
			AlbTextWordPieceScreenToCursorHandler uniqueInstance.

			AlbTextWordPieceFocusHandler uniqueInstance.
			AlbTextWordPieceBlurHandler uniqueInstance.
			
			"selection changed in the editor, select a given interval"
			AlbTextWordPieceSelectionHandler uniqueInstance.
			
			"selection changed in the editor, deselect a given interval"
			AlbTextWordPieceDeselectionHandler uniqueInstance.
			
			"text changed in the editor"
			AlbTextWordPieceTextChangeHandler uniqueInstance.	

			"text piece got inside of selected area"
			AlbTextWordPieceSelectionAcquiredHandler uniqueInstance.

			"text piece got outside of then selected area"
			AlbTextWordPieceSelectionLostHandler uniqueInstance. }

	
]

{ #category : #initialization }
AlbTextWordPieceStencilBuilder >> reset [
	wordPadding := BlInsets empty.
	wordMargin := BlInsets empty.
	segmentPiece := nil
]

{ #category : #accessing }
AlbTextWordPieceStencilBuilder >> segmentPiece [
	<return: #TAlbTextEditorTextualPiece>

	^ segmentPiece
]

{ #category : #accessing }
AlbTextWordPieceStencilBuilder >> segmentPiece: aTAlbTextEditorTextualPiece [
	segmentPiece := aTAlbTextEditorTextualPiece
]

{ #category : #accessing }
AlbTextWordPieceStencilBuilder >> wordMargin [
	<return: #BlInsets>

	^ wordMargin
]

{ #category : #accessing }
AlbTextWordPieceStencilBuilder >> wordMargin: aBlInsets [
	wordMargin := aBlInsets
]

{ #category : #accessing }
AlbTextWordPieceStencilBuilder >> wordPadding [
	<return: #BlInsets>

	^ wordPadding
]

{ #category : #accessing }
AlbTextWordPieceStencilBuilder >> wordPadding: aBlInsets [
	wordPadding := aBlInsets
]
