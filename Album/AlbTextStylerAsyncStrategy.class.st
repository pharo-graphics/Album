"
I am a text styler strategy used by ${class:BrTextEditor}$.
I style a text in a bacground process using ${method:BlockClosure>>#forkAt:named:}$.

See ${class:BrTextStylerStrategy}$ for futher explanation.

Example: ${example:BrTextStylerExamples>>#editorWithAsyncStylerStrategy|codeExpanded=false|previewExpanded=true}$


"
Class {
	#name : #AlbTextStylerAsyncStrategy,
	#superclass : #AlbTextStylerCommonAsyncStrategy,
	#instVars : [
		'backgroundProcess',
		'delay'
	],
	#category : #'Album-Styler'
}

{ #category : #accessing }
AlbTextStylerAsyncStrategy >> delay [
	<return: #Duration>

	^ delay
]

{ #category : #accessing }
AlbTextStylerAsyncStrategy >> delay: aDuration [

	delay := aDuration
]

{ #category : #private }
AlbTextStylerAsyncStrategy >> doStyle: aEditorElement afterDo: aBlock [

	self delay isZero ifFalse: [ self delay wait ].
	self enqueueTaskOn: aEditorElement afterDo: aBlock
]

{ #category : #private }
AlbTextStylerAsyncStrategy >> enqueueTaskOn: aEditorElement afterDo: aBlock [
	"Enqueue a task into a editor element to style its text. This will dispatch a BrTextStyledEvent with the after block closure."

	| aStyledText |
	aEditorElement enqueueTask: (BlTaskAction new action: [
		aStyledText := self
               doStyleText: aEditorElement editor text
               with: aEditorElement editor styler
               afterDo: aBlock.

		aEditorElement editor dispatchEvent: (AlbTextStyledEvent new
			 text: aStyledText;
			 afterAction: aBlock;
			 editorElement: aEditorElement) ])
]

{ #category : #initialization }
AlbTextStylerAsyncStrategy >> initialize [

	super initialize.
	delay := 200 milliSeconds.
]

{ #category : #styling }
AlbTextStylerAsyncStrategy >> scheduleStyleTextInEditorElement: aEditorElement thenDo: aBlock [

	BlUseAsyncFeatures 
		ifEnabledDo: [  
			monitor critical: [ 
				self terminateBackgroundStylingProcess.
				backgroundProcess := [
					self doStyle: aEditorElement afterDo: aBlock 
				] forkAt: Processor userBackgroundPriority named: 'Text Styler Async Task' ] ]
		otherwise: [ self doStyle: aEditorElement afterDo: aBlock ]
]

{ #category : #private }
AlbTextStylerAsyncStrategy >> terminateBackgroundStylingProcess [
	"Must be called in a monitor critical block."
	backgroundProcess ifNotNil: [ :aProcess |
		aProcess terminate.
		backgroundProcess := nil ]
]
