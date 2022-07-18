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

		spec
			package: #'#Album' ;
			package: #'#Album-Tests' ;
			package: #'Album-Examples';
			package: #'Album-Brick-NU';
			package: #'Album-Sparta' ]
]

{ #category : #baselines }
BaselineOfAlbum >> declareBlocOn: spec [

	spec
		baseline: 'Bloc'
		with: [ spec repository: 'github://pharo-graphics/Bloc:dev-1.0/src' ]
]
