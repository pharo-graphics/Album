"
I am a text styler strategy used by ${class:AlbTextEditor}$.
I style a text in the same active process, which should be a Bloc UI process to display the styled text properly to a user.

See ${class:AlbTextStylerStrategy}$ for futher explanation.

Example: ${example:AlbTextStylerExamples>>#editorWithSyncStylerStrategy|codeExpanded=false|previewExpanded=true}$


"
Class {
	#name : #AlbTextStylerSyncStrategy,
	#superclass : #AlbTextStylerStrategy,
	#category : #'Album-Styler'
}

{ #category : #styling }
AlbTextStylerSyncStrategy >> styleTextInEditorElement: aEditorElement thenDo: aBlock [

	| aStyledText |
	aStyledText := self
		doStyleText: aEditorElement editor textSnapshot
		with: aEditorElement editor styler
		afterDo: aBlock.

	"Dispatch the event in the UI thread. Needed?"
	aEditorElement enqueueTask: (BlTaskAction new action: [
		aEditorElement editor dispatchEvent: (AlbTextStyledEvent new
			text: aStyledText;
			afterAction: aBlock;
			editorElement: aEditorElement) ])
]
