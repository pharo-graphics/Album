"
Hello World *https://gtoolkit.com*
"
Class {
	#name : #AlbTextStylerExamples,
	#superclass : #Object,
	#category : #'Album-Examples-Editor'
}

{ #category : #'examples - editor' }
AlbTextStylerExamples >> codeSnippetStyler [
	<gtExample>

	^ AlbRBTextStyler new classOrMetaClass: BlElement
]

{ #category : #'examples - styler strategy' }
AlbTextStylerExamples >> editorWithAsyncStylerStrategy [
	<gtExample>
	<noTest>
	| anEditor aStyler theTextAttributes aSemaphore aTimeout anElement aSpace |
	anEditor := self editorWithMethod.
	aStyler := self codeSnippetStyler.
	anEditor useAsyncStylerStrategy.
	anEditor styler: aStyler.
	self assert: anEditor stylerStrategy class equals: AlbTextStylerAsyncStrategy.
	theTextAttributes := anEditor text attributesAt: 1.
	self assert: theTextAttributes size isZero.
	aSemaphore := Semaphore new.

	"Async styler strategy needs a view"
	anElement := AlbEditorElement new editor: anEditor. 
	anEditor styleTextAndAfterDo: [ :aStyledText | aSemaphore signal ].

	aTimeout := aSemaphore waitTimeoutMSecs: 100.
	"It timeouts anyway as the element is not in a Space yet."
	self assert: aTimeout.

	"since an element was not attached to the space it has one task pending"
	self assert: anElement taskQueue tasks size equals: 0.
	
	aSpace := OBlSpace new.
	aSpace host: BlMockedHost new.
	aSpace addChild: anElement.
	"We simulate the task execution that triggers styling"
	BlUseAsyncFeatures disableDuring: [ aSpace pulse ].
	
	"no more tasks"
	self assert: anElement taskQueue tasks size equals: 0.
	
	aTimeout := aSemaphore waitTimeoutMSecs: 100.
	"It does not timeout as styling is processed in the same process as this test."
	self assert: aTimeout not.
	
	"And the text is finally styled"
	theTextAttributes := anEditor text attributesAt: 1.
	self assert: theTextAttributes size isZero not.
	^ anEditor
	
]

{ #category : #'examples - editor' }
AlbTextStylerExamples >> editorWithMethod [
	<gtExample>

	^ self newEditor text: self newMethodText
]

{ #category : #'examples - styler strategy' }
AlbTextStylerExamples >> editorWithSyncStylerStrategy [
	<gtExample>
	| anEditor anEditorElement aStyler theTextAttributes |

	anEditor := self editorWithMethod.	
	aStyler := self codeSnippetStyler.
	
	anEditorElement := AlbEditorElement new.
	anEditorElement editor: anEditor.

	anEditor useSyncStylerStrategy.
	anEditor styler: aStyler.
	self assert: anEditor stylerStrategy class equals: AlbTextStylerSyncStrategy.
	theTextAttributes := anEditor text attributesAt: 1.
	self assert: theTextAttributes size isZero not.

	^ anEditor
	
]

{ #category : #'instance creation' }
AlbTextStylerExamples >> newEditor [
	<gtExample>

	^ AlbTextEditor new
]

{ #category : #'instance creation' }
AlbTextStylerExamples >> newMethodText [
	<gtExample>
	
	^ (BlElement >> #applyLayoutSafelyIn:context:) sourceCode asRopedText
]

{ #category : #defaults }
AlbTextStylerExamples >> timeoutMilliseconds [
	^ 500
]
