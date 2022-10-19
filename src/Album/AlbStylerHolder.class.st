Class {
	#name : #AlbStylerHolder,
	#superclass : #Object,
	#traits : 'TBlAnnouncerProvider + TBlTextStylerClient + TObservable',
	#classTraits : 'TBlAnnouncerProvider classTrait + TBlTextStylerClient classTrait + TObservable classTrait',
	#instVars : [
		'#unstyledText => ObservableSlot',
		'#styledText => ObservableSlot',
		'#referentElement',
		'#fontName'
	],
	#category : #'Album-Model'
}

{ #category : #accessing }
AlbStylerHolder >> fontName [

	^ fontName
]

{ #category : #accessing }
AlbStylerHolder >> fontName: aFontName [

	fontName := aFontName.
	self stylerDo: [ :s | s fontName: aFontName ] 
]

{ #category : #initialization }
AlbStylerHolder >> initialize [

	self class initializeSlots: self.
	super initialize.
	announcer := Announcer new.
	self whenUnstyledTextChangedDo: [ 
		self launchTextStyle ]
]

{ #category : #styling }
AlbStylerHolder >> launchTextStyle [

	self stylerDo: [ 
		self unstyledText ifNotNil: [ self launchStyle: self unstyledText nextGeneration in: self referentElement ] ]
]

{ #category : #accessing }
AlbStylerHolder >> referentElement [

	" get the element which can enqueue a styling task "
	^ referentElement
]

{ #category : #accessing }
AlbStylerHolder >> referentElement: anElement [

	" set the element which can enqueue a styling task "
	referentElement := anElement
]

{ #category : #'api - styler hook' }
AlbStylerHolder >> requestTextStyle [

	self launchTextStyle 
]

{ #category : #accessing }
AlbStylerHolder >> styledText [

	^ styledText 
]

{ #category : #accessing }
AlbStylerHolder >> styledText: aBlText [

	styledText := aBlText
]

{ #category : #accessing }
AlbStylerHolder >> unstyledText [

	^ unstyledText 
]

{ #category : #accessing }
AlbStylerHolder >> unstyledText: aBlText [

	" observable slot "

	unstyledText := aBlText
]

{ #category : #'slot - change hook' }
AlbStylerHolder >> whenStyledTextChangedDo: aBlock [

	"set a block to perform after that the mode has been chanbed, and its action performed"

	self property: #styledText whenChangedDo: aBlock
]

{ #category : #'api - styler hook' }
AlbStylerHolder >> whenTextStyled: aBlStylerTextStyleAnnouncement [

	| result |
	result := aBlStylerTextStyleAnnouncement styledText.
	" text just styled by the styler, check the generation (to be thread-safe) to ensure that my text has not be changed elsewhere during the styling "
	(result isNextGenerationOf: self unstyledText) ifFalse: [ ^ self ].
	" observable slot update "
	styledText := result
]

{ #category : #'slot - change hook' }
AlbStylerHolder >> whenUnstyledTextChangedDo: aBlock [

	"set a block to perform after that the mode has been chanbed, and its action performed"

	self property: #unstyledText whenChangedDo: aBlock
]
