Class {
	#name : #DependencyGraph,
	#superclass : #Object,
	#instVars : [
		'root',
		'packages',
		'flowGraph'
	],
	#category : #FlutterDependenciesPackager
}

{ #category : #initialization }
DependencyGraph >> buildGraph: aFlutterPackage [

	| currentNode |
	self flowGraph definitions isEmpty ifTrue: [ root := aFlutterPackage ].

	currentNode := MeFCNode named: aFlutterPackage exportPackageName.


	(packages includes: aFlutterPackage) ifFalse: [ 
		packages add: aFlutterPackage.
		flowGraph addDefinition: currentNode ].

	aFlutterPackage childrenDep do: [ :dep | 
		| link childNode |
		childNode := MeFCNode named: dep exportPackageName.

		(packages includes: dep) ifFalse: [ 
			flowGraph addDefinition: childNode.
			packages add: dep ].

		link := MeFCLink newFromNode: currentNode toNode: childNode.
		link toArrowType: MeFCArrowHeadType new.
		flowGraph addDefinition: link.
		self buildGraph: dep ].

	^ self.
]

{ #category : #initialization }
DependencyGraph >> buildGraphVanilla: aFlutterPackage [

	| currentNode |
	self flowGraph definitions isEmpty ifTrue: [ root := aFlutterPackage ].

	currentNode := MeFCNode named: aFlutterPackage exportPackageName.
		packages add: aFlutterPackage.
		flowGraph addDefinition: currentNode.

	aFlutterPackage childrenDep do: [ :dep | 
		| link childNode |
		childNode := MeFCNode named: dep exportPackageName.

flowGraph addDefinition: childNode.
			packages add: dep.
	

		link := MeFCLink newFromNode: currentNode toNode: childNode.
		link toArrowType: MeFCArrowHeadType new.
		flowGraph addDefinition: link.
		self buildGraphVanilla: dep ].

	^ self
]

{ #category : #initialization }
DependencyGraph >> flowGraph [

	^ flowGraph
]

{ #category : #initialization }
DependencyGraph >> initialize [

	root := FlutterPackage new.
	packages := OrderedCollection new.
	flowGraph := MeFlowchartDiagram new
]
