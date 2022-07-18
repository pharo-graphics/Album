Class {
	#name : #BaselineOfAlbum,
	#superclass : #BaselineOf,
	#category : #BaselineOfAlbum
}

{ #category : #baselines }
BaselineOfAlbum >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		self declareBlocOn: spec.
		spec
			baseline: 'OnBloc'
			with: [ spec repository: 'github://plantec/OnBloc/src' ].
		"Sparta"
		spec
			baseline: 'Sparta'
			with: [ 
			spec repository: 'github://pharo-graphics/Sparta:dev-1.0/src' ].
		spec
			baseline: 'Alexandrie'
			with: [ 
			spec repository: 'github://pharo-graphics/Alexandrie:master/src' ].

		spec package: #Album with: [ 
			spec repository: 'github://plantec/Album/src'.
			spec requires: #( #OnBloc #Alexandrie ) ].

		spec package: #'Album-Sparta' with: [ 
			spec repository: 'github://plantec/Album/src'.
			spec requires: #( #OnBloc ) ].
		spec
			package: #'#Album-Tests' with: [ spec requires: #( #Album ) ];
			package: #'Album-Examples' with: [ spec requires: #( #Album ) ];
			package: #'Album-Brick-NU' with: [ spec requires: #( #Album ) ] ]
]

{ #category : #baselines }
BaselineOfAlbum >> declareBlocOn: spec [

	spec
		baseline: 'Bloc'
		with: [ spec repository: 'github://pharo-graphics/Bloc:dev-1.0/src' ]
]
