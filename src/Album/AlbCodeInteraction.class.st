Class {
	#name : #AlbCodeInteraction,
	#superclass : #Object,
	#instVars : [
		'owner'
	],
	#category : #'Album-Model'
}

{ #category : #accessing }
AlbCodeInteraction >> behavior [

	^ nil
]

{ #category : #binding }
AlbCodeInteraction >> bindingOf: aString [

	^ nil
]

{ #category : #accessing }
AlbCodeInteraction >> bindings [

	"no additional bindings provided by the Requestor"

	^ #() asDictionary
]

{ #category : #accessing }
AlbCodeInteraction >> doItContext [

	^ nil
]

{ #category : #accessing }
AlbCodeInteraction >> doItReceiver [

	^ nil
]

{ #category : #binding }
AlbCodeInteraction >> hasBindingOf: aString [

	^ false
]

{ #category : #testing }
AlbCodeInteraction >> hasBindingThatBeginsWith: aString [

	^ self variableBindingNames 
		anySatisfy: [ :each | each beginsWith: aString ]
]

{ #category : #testing }
AlbCodeInteraction >> isScripting [

	^ false
]

{ #category : #'interactive error protocol' }
AlbCodeInteraction >> notify: message at: location in: code [

]

{ #category : #'api - hooks' }
AlbCodeInteraction >> onInstalledIn: aViewModel [
]

{ #category : #'api - hooks' }
AlbCodeInteraction >> onUninstalledIn: aViewModel [
]

{ #category : #accessing }
AlbCodeInteraction >> owner [

	^ owner
]

{ #category : #accessing }
AlbCodeInteraction >> owner: aPresenter [

	owner := aPresenter
]

{ #category : #accessing }
AlbCodeInteraction >> selectedBehavior [

	^ self behavior
]

{ #category : #accessing }
AlbCodeInteraction >> selectedClass [

	^ self behavior
]

{ #category : #accessing }
AlbCodeInteraction >> selectedClassOrMetaClass [

	^ self behavior
]

{ #category : #accessing }
AlbCodeInteraction >> text [

	^ self owner text
]

{ #category : #accessing }
AlbCodeInteraction >> variableBindingNames [
	
	^ self variableBindings keys
]

{ #category : #accessing }
AlbCodeInteraction >> variableBindings [

	^ Dictionary new
]
