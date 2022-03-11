Class {
	#name : #AlbTextEditableWordPieceStencilBuilder,
	#superclass : #AlbTextWordPieceStencilBuilder,
	#classVars : [
		'TextPiecePool'
	],
	#category : #'Album-UI-Stencils'
}

{ #category : #'class initialization' }
AlbTextEditableWordPieceStencilBuilder class >> cleanUp [
	self initialize
]

{ #category : #'class initialization' }
AlbTextEditableWordPieceStencilBuilder class >> initialize [
	"self initialize "
	TextPiecePool := BlSynchronizedObjectPool pool: (BlBagObjectPool new: 1000)
]

{ #category : #'api - instantiation' }
AlbTextEditableWordPieceStencilBuilder >> createWordElement [
	<return: #AlbTextElementWithCursors>

	^ BrTextElementWithCursors new
			editorMeasurement;

			"to support event-handling attributes"
			addEventHandler: BrTextEditorLineSegmentTextListener uniqueInstance;

			"editor requests to show a cursor as a result of its position change"
			addEventHandler: BrTextWordPieceShowCursorHandler uniqueInstance;

			"editor requests to remove a cursor as a result of its position change"
			addEventHandler: BrTextWordPieceHideCursorHandler uniqueInstance;
			
			"for screen position to cursor index transformation"
			addEventHandler: BrTextWordPieceScreenToCursorHandler uniqueInstance;

			addEventHandler: BrTextWordPieceFocusHandler uniqueInstance;
			addEventHandler: BrTextWordPieceBlurHandler uniqueInstance;
			
			"selection changed in the editor, select a given interval"
			addEventHandler: BrTextWordPieceSelectionHandler uniqueInstance;
			
			"selection changed in the editor, deselect a given interval"
			addEventHandler: BrTextWordPieceDeselectionHandler uniqueInstance;
			
			"text changed in the editor"
			addEventHandler: BrTextWordPieceTextChangeHandler uniqueInstance;		

			"text piece got inside of selected area"
			addEventHandler: BrTextWordPieceSelectionAcquiredHandler uniqueInstance;

			"text piece got outside of then selected area"
			addEventHandler: BrTextWordPieceSelectionLostHandler uniqueInstance;

			yourself
]

{ #category : #'private - pool' }
AlbTextEditableWordPieceStencilBuilder >> pool [
	^ TextPiecePool
]
