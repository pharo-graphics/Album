Class {
	#name : 'AlbEditorCarriageReturnShortcut',
	#superclass : 'AlbEditorShortcut',
	#category : 'Album-Shortcuts',
	#package : 'Album',
	#tag : 'Shortcuts'
}

{ #category : 'accessing' }
AlbEditorCarriageReturnShortcut >> description [
	^ 'Inserts a carriage return (cr) at the cursor location and indents the new line to match the indentation of the previous line.'
]

{ #category : 'initialization' }
AlbEditorCarriageReturnShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination return
]

{ #category : 'accessing' }
AlbEditorCarriageReturnShortcut >> name [
	^ 'Insert carriage return'
]

{ #category : 'evaluation' }
AlbEditorCarriageReturnShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [

	aTextEditor inserter
		inputFilter: aTextEditor inputFilter;
		atCursor;
		crLineEndingWithWhitespace;
		insert
]
