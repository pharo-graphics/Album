Class {
	#name : #BaselineOfAlbum,
	#superclass : #BaselineOf,
	#category : #BaselineOfAlbum
}

{ #category : #baselines }
BaselineOfAlbum >> baseline: spec [

	<baseline>
	spec for: #common do: [ 

		spec
			baseline: 'OnBloc'
			with: [ spec repository: 'github://plantec/OnBloc/src' ].
		spec
			baseline: 'Sparta'
			with: [ 
			spec repository: 'github://pharo-graphics/Sparta:dev-1.0/src' ].
		spec
			baseline: 'Alexandrie'
			with: [ 
			spec repository: 'github://pharo-graphics/Alexandrie:master/src' ].

		spec
			package: #'Album' with: [ 
				spec requires: #( #OnBloc #Sparta #Alexandrie ) ];
			package: #'Album-Tests' with: [ 
				spec requires: #( #OnBloc #Sparta #Alexandrie ) ];
			package: #'Album-Examples' with: [ 
				spec requires: #( #OnBloc #Sparta #Alexandrie ) ];
			package: #'Album-Brick-NU' with: [ 
				spec requires: #( #OnBloc #Sparta #Alexandrie ) ];
			package: #'Album-Sparta' with: [ 
				spec requires: #( #OnBloc #Sparta #Alexandrie ) ] ] 
]
