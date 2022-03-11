"
I am a text styler strategy used by ${class:BrTextEditor}$.
I style a text in a TaskIt background process using ${class:BlTktWorkerProvider}$.

See ${class:BrTextStylerStrategy}$ for futher explanation.

Example: ${example:BrTextStylerExamples>>#editorWithTaskItStylerStrategy|codeExpanded=false|previewExpanded=true}$


"
Class {
	#name : #AlbTextStylerTaskItStrategy,
	#superclass : #AlbTextStylerCommonAsyncStrategy,
	#instVars : [
		'command'
	],
	#category : #'Album-Styler'
}

{ #category : #private }
AlbTextStylerTaskItStrategy >> commandNameFromText: aText [
	^ aText isEmpty
		ifTrue: [ '<empty query>' ]
		ifFalse: [ (aText from: 1 to: (aText size min: 20)) printString ]
]

{ #category : #'instance creation' }
AlbTextStylerTaskItStrategy >> newStylingCommandFor: aBlText with: aStyler inEditorElement: aEditorElement afterDo: aBlock [
	<return: #BlTktTerminableCommand>
	| aName aCommand |
	aName := self commandNameFromText: aBlText.
	aCommand := [
		| aStyledText |
		aStyledText := self doStyleText: aBlText with: aStyler afterDo: aBlock.
		aEditorElement enqueueTask: (BlTaskAction new action: [
			aEditorElement editor dispatchEvent: (AlbTextStyledEvent new
				text: aStyledText;
				afterAction: aBlock;
				editorElement: aEditorElement) ]).
		command := nil ] asBlTktTerminableCommand asBlTktLoggingCommand.
	aCommand name: 'Text Styler for ''' , aName , ''''.
	^ aCommand
]

{ #category : #private }
AlbTextStylerTaskItStrategy >> scheduleStyleTextInEditorElement: aEditorElement thenDo: aBlock [
	| aTextToStyle aStyler |
	
	aStyler := aEditorElement editor styler.
	aTextToStyle := aEditorElement editor text.

	BlUseAsyncFeatures 
		ifEnabledDo: [ 
			monitor critical: [ 
				self terminateBackgroundStylingProcess.

				BlTktWorkerProvider textStylerPool
					schedule: (command := self
						newStylingCommandFor: aTextToStyle
						with: aStyler
						inEditorElement: aEditorElement
						afterDo: aBlock) ] ]
		otherwise: [
			| aStyledText |
			aStyledText := self doStyleText: aTextToStyle with: aStyler afterDo: aBlock.
			aEditorElement editor dispatchEvent: (AlbTextStyledEvent new
				text: aStyledText;
				afterAction: aBlock;
				editorElement: aEditorElement) ]
]

{ #category : #private }
AlbTextStylerTaskItStrategy >> terminateBackgroundStylingProcess [
	"Must be called within monitor critical code"
	command ifNotNil: [ :aCommand |
		aCommand terminate.
		command := nil ]
]
