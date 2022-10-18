Class {
	#name : #AlbTextWordPieceStencil,
	#superclass : #OBlStencil,
	#instVars : [
		'wordPadding',
		'wordMargin',
		'segmentPiece',
		'readOnly',
		'measurer'
	],
	#category : #'Album-UI-Stencils'
}

{ #category : #'instance creation' }
AlbTextWordPieceStencil class >> editable [

	^ self new beEditable
]

{ #category : #'instance creation' }
AlbTextWordPieceStencil class >> forTextEditorMode: aTextEditorMode [

	^ aTextEditorMode isReadOnly
		  ifTrue: [ self readOnly ]
		  ifFalse: [ self editable ]
]

{ #category : #'instance creation' }
AlbTextWordPieceStencil class >> readOnly [

	^ self new beReadOnly
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencil >> allEventHandlers [

	^ readOnly
		  ifTrue: [ self readOnlyWordPieceEventHandlers ]
		  ifFalse: [ self editableWordPieceEventHandlers ]
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencil >> beEditable [

	readOnly := false
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencil >> beReadOnly [ 

	readOnly := true
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencil >> create [

	| aTextElement |
	aTextElement := self createWordElement
		                segmentPiece: self segmentPiece;
		                padding: self wordPadding;
		                margin: self wordMargin.

	self reset.
	^ aTextElement
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencil >> createWordElement [

	<return: #AlbTextElements>
	| wordElement |
	wordElement := AlbTextElement new.
	measurer ifNotNil: [ wordElement measurer: measurer ].
	wordElement editorMeasurement.
	self allEventHandlers do: [ :e | wordElement addEventHandler: e ].
	^ wordElement
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencil >> editableWordPieceEventHandlers [

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
AlbTextWordPieceStencil >> initialize [
	super initialize.
	readOnly := false.	
	self reset
]

{ #category : #accessing }
AlbTextWordPieceStencil >> measurer [
	<return: #BlTextElementMeasurer>

	^ measurer
]

{ #category : #accessing }
AlbTextWordPieceStencil >> measurer: aBlTextElementMeasurer [

	measurer := aBlTextElementMeasurer
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencil >> readOnlyWordPieceEventHandlers [

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
AlbTextWordPieceStencil >> reset [
	wordPadding := BlInsets empty.
	wordMargin := BlInsets empty.
	segmentPiece := nil
]

{ #category : #accessing }
AlbTextWordPieceStencil >> segmentPiece [
	<return: #TAlbTextEditorTextualPiece>

	^ segmentPiece
]

{ #category : #accessing }
AlbTextWordPieceStencil >> segmentPiece: aTAlbTextEditorTextualPiece [
	segmentPiece := aTAlbTextEditorTextualPiece
]

{ #category : #accessing }
AlbTextWordPieceStencil >> wordMargin [
	<return: #BlInsets>

	^ wordMargin
]

{ #category : #accessing }
AlbTextWordPieceStencil >> wordMargin: aBlInsets [
	wordMargin := aBlInsets
]

{ #category : #accessing }
AlbTextWordPieceStencil >> wordPadding [
	<return: #BlInsets>

	^ wordPadding
]

{ #category : #accessing }
AlbTextWordPieceStencil >> wordPadding: aBlInsets [
	wordPadding := aBlInsets
]
