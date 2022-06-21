Class {
	#name : #AlbWidgetModel,
	#superclass : #AlbActor,
	#instVars : [
		'model',
		'whenAttachedActions'
	],
	#category : #'Album-Brick-NU-Model'
}

{ #category : #'api - composition' }
AlbWidgetModel class >> + anotherModel [
	self deprecated: 'use #add: instead'.
	^ self asModel + anotherModel
]

{ #category : #'api - composition' }
AlbWidgetModel class >> asModel [
	^ self new
]

{ #category : #printing }
AlbWidgetModel class >> modelName [
	^ self name
]

{ #category : #'api - composition' }
AlbWidgetModel >> + anotherModel [
	self deprecated: 'use #add: instead'.
	self add: anotherModel asModel
]

{ #category : #'api - composition' }
AlbWidgetModel >> add: aWidgetModel [
	actors := actors copyWith: aWidgetModel.
	self widgetDo: [ :anElement | aWidgetModel onInstalledIn: anElement ]
]

{ #category : #'api - composition' }
AlbWidgetModel >> addAll: aCollectionOfWidgetModels [
	aCollectionOfWidgetModels do: [ :aWidgetModel | self add: aWidgetModel ]
]

{ #category : #'api - composition' }
AlbWidgetModel >> asModel [
	^ self
]

{ #category : #'event management' }
AlbWidgetModel >> dispatchViewModelAttachedEvent [
	"ViewModelAttached event is listened by Looks to request data from view model.
	If widget has no look attached yet, then there is no need to send this event at all"
	| aCopyOfActions |
	
	aCopyOfActions := whenAttachedActions copy.
	
	whenAttachedActions := OrderedCollection new.
	aCopyOfActions do: [ :eachAction | eachAction cull: widget ]
]

{ #category : #initialization }
AlbWidgetModel >> initialize [
	super initialize.

	whenAttachedActions := OrderedCollection new
]

{ #category : #accessing }
AlbWidgetModel >> model [
	^ model
]

{ #category : #accessing }
AlbWidgetModel >> model: anObject [
	model := anObject
]

{ #category : #printing }
AlbWidgetModel >> modelName [
	^ self class modelName
]

{ #category : #hooks }
AlbWidgetModel >> onInstalledIn: anElement [
	super onInstalledIn: anElement.

	self dispatchViewModelAttachedEvent.	
	self widgetModels do: [ :aWidgetModel | aWidgetModel onInstalledIn: anElement ]
]

{ #category : #hooks }
AlbWidgetModel >> onUninstalledIn: anElement [
	super onUninstalledIn: anElement.

	self
		assert: [ self widget == anElement ]
		description: [ 'Can not uninstall from a different widget' ].

	self widgetModels reversed do: [ :aWidgetModel | aWidgetModel onUninstalledIn: anElement ].
	widget := nil.
	self initializeListeners
]

{ #category : #'event management' }
AlbWidgetModel >> when: aRequestClass reply: aBlock [
	self when: aRequestClass do: [ :aRequest |
		| aReplyEvent |
		
		aRequest consumed: true.

		aReplyEvent := aBlock cull: (aRequest responseFor: self) cull: aRequest.

		aRequest canRespond
			ifTrue: [ aRequest response: aReplyEvent ].

		aReplyEvent source: self.
		
		aRequest isConsumed ifTrue: [ 
			aRequest isOneWay ifFalse: [ 
				aRequest source dispatchEvent: aReplyEvent ] ] ]
]

{ #category : #'event management' }
AlbWidgetModel >> whenAttachedDo: aBlockClosure [
	"Evaluate a aBlockClosure as *once* when I am attached to the widget.
	If I am already attached to the widget evaluate the aBlockClosure right away"

	self isAttachedToWidget
		ifTrue: [ aBlockClosure cull: self widget ]
		ifFalse: [ whenAttachedActions add: aBlockClosure ]
]

{ #category : #accessing }
AlbWidgetModel >> widgetModels [
	<return: #Collection of: #AlbWidgetModel>

	^ self children
]
