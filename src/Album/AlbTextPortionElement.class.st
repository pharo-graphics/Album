Class {
	#name : #AlbTextPortionElement,
	#superclass : #BlElement,
	#category : #'Album-UI-Text-Portion'
}

{ #category : #accessing }
AlbTextPortionElement >> borderColor [

	^ Color gray alpha: 0.2
]

{ #category : #accessing }
AlbTextPortionElement >> borderWidth [

	^ 1
]

{ #category : #initialization }
AlbTextPortionElement >> defaultBackground [ 

	^ Color lightGray alpha: 0.2
]

{ #category : #accessing }
AlbTextPortionElement >> defaultBorder [

	^ BlBorder paint: self borderColor width: self borderWidth
]

{ #category : #initialization }
AlbTextPortionElement >> initialize [ 

	super initialize.
	self background: self defaultBackground.
	self border:	self defaultBorder.
	self constraintsDo: [ :c | c ignoreByLayout  ]
]
