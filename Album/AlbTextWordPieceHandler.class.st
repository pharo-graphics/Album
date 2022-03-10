Class {
	#name : #AlbTextWordPieceHandler,
	#superclass : #BlBasicEventHandler,
	#category : #'Album-UI-Word'
}

{ #category : #accessing }
AlbTextWordPieceHandler >> eventClass [
	^ self subclassResponsibility
]

{ #category : #'api - event managing' }
AlbTextWordPieceHandler >> globalTextIndexToLocal: aTextIndex in: aTextEditElement [
	"Convert global text index given in the text coordinates of the whole editor to a local index within this segment piece.
	This convertion is necessary due to the fact that text elements that represent every segment piece work with text in their own local system"
	<return: #Number>

	^ aTextIndex + aTextEditElement textStart
]

{ #category : #'api - event managing' }
AlbTextWordPieceHandler >> handleEvent: anEvent [
	self subclassResponsibility
]

{ #category : #'api - event managing' }
AlbTextWordPieceHandler >> localTextIndexToGlobal: aTextIndex in: aTextEditElement [
	"Convert local text index given in the text coordinates of the given text piece to a global index within the whole text editor.
	This convertion is necessary due to the fact that text elements that represent every segment piece work with text in their own local system"
	<return: #Number>
	
	^ aTextEditElement textStart + aTextIndex
]

{ #category : #'api - event managing' }
AlbTextWordPieceHandler >> wantsEvent: anEvent [
	^ anEvent class = self eventClass or: [ anEvent class inheritsFrom: self eventClass ]
]
