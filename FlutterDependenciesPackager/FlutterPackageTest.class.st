Class {
	#name : #FlutterPackageTest,
	#superclass : #TestCase,
	#instVars : [
		'pkg'
	],
	#category : #FlutterDependenciesPackager
}

{ #category : #running }
FlutterPackageTest >> setUp [
	super setUp.
	
	pkg := FlutterPackage new.
]

{ #category : #initialization }
FlutterPackageTest >> testInitialize [

	
]

{ #category : #initialization }
FlutterPackageTest >> testPath [

	| aPath nbDartFiles |
	aPath := (FileLocator home)
	         / '.pub-cache/hosted/pub.dartlang.org/analyzer-1.7.2'.
	pkg path: aPath.
	nbDartFiles := (pkg path allChildrenMatching: '*.dart') size.
	self assert: nbDartFiles > 0 equals: true
]

{ #category : #initialization }
FlutterPackageTest >> testPubpspecYamlFileLocator [

	| aPath pubspec |
	aPath := FileLocator home
	         / '.pub-cache/hosted/pub.dartlang.org/analyzer-1.7.2'.
	pkg path: aPath.

	pubspec := (pkg path allChildrenMatching: 'pubspec.yaml') first.
	self assert: pubspec equals: pkg pubpspecYamlFileLocator
]

{ #category : #initialization }
FlutterPackageTest >> testPubspecToJson [

	| aPath pubspec y2j |
	aPath := FileLocator home
	         / '.pub-cache/hosted/pub.dartlang.org/analyzer-1.7.2'.
	pkg path: aPath.
	y2j := Yaml2Json new. 
	y2j convertPubSpecYamlToJson: ( pkg pubpspecYamlFileLocator toString).
	
	pubspec := (pkg path allChildrenMatching: 'pubspec.yaml') first.
	self assert: pubspec equals: pkg pubpspecYamlFileLocator
]
