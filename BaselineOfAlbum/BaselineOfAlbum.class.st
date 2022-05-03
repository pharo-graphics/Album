Class {
	#name : #BaselineOfAlbum,
	#superclass : #BaselineOf,
	#category : #BaselineOfAlbum
}

{ #category : #baselines }
BaselineOfAlbum >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec 
			baseline: 'Bloc' with: [
				spec repository: 'github://pharo-graphics/bloc:dev-1.0/src' ];
			baseline: 'BlocPac' with: [
				spec repository: 'github://pharo-graphics/bloc-pac:dev-1.0/src' ].

		spec 
			package: #'Album' with: [
				spec repository: 'github://plantec/Album:dresser/src'.
				spec requires: #(#'Bloc' #'BlocPac') ]
			 ].
]
