Class {
	#name : #AlbTextReadonlyWordPieceStencilBuilder,
	#superclass : #AlbTextWordPieceStencilBuilder,
	#category : #'Album-UI-Stencils'
}

{ #category : #'api - instantiation' }
AlbTextReadonlyWordPieceStencilBuilder >> createWordElement [
	<return: #AlbTextElementWithCursors>

	^ AlbTextElementWithCursors new
			editorMeasurement;

			"to support event-handling attributes"
			addEventHandler: AlbTextEditorLineSegmentTextListener uniqueInstance;
			
			"for screen position to cursor index transformation"
			addEventHandler: AlbTextWordPieceScreenToCursorHandler uniqueInstance;

			addEventHandler: AlbTextWordPieceFocusHandler uniqueInstance;
			addEventHandler: AlbTextWordPieceBlurHandler uniqueInstance;
			
			"selection changed in the editor, select a given interval"
			addEventHandler: AlbTextWordPieceSelectionHandler uniqueInstance;
			
			"selection changed in the editor, deselect a given interval"
			addEventHandler: AlbTextWordPieceDeselectionHandler uniqueInstance;
			
			"text changed in the editor"
			addEventHandler: AlbTextWordPieceTextChangeHandler uniqueInstance;		

			"text piece got inside of selected area"
			addEventHandler: AlbTextWordPieceSelectionAcquiredHandler uniqueInstance;

			"text piece got outside of then selected area"
			addEventHandler: AlbTextWordPieceSelectionLostHandler uniqueInstance;

			yourself
]
