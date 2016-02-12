# LFSCoreData

[![Version](http://cocoapod-badges.herokuapp.com/v/LFSCoreData/badge.png)](http://cocoadocs.org/docsets/LFSCoreData)
[![Platform](http://cocoapod-badges.herokuapp.com/p/LFSCoreData/badge.png)](http://cocoadocs.org/docsets/LFSCoreData)
[![Build Status](https://travis-ci.org/lafosca/LFSCoreData.png?branch=master)](https://travis-ci.org/lafosca/LFSCoreData)

## Description

LFSCoreData is an iOS and MacOSX open-source library to help the developer to start Core Data Framework based applications easily. Manage your application database bootstraping, saving in background and mapping from an API easily. 

To run the example project; clone the repo, and run `pod install` from the Project directory first.

## Features

* Easy setup and clean AppDelegate
* Easily import API data from JSON data
* Custom field naming
* Save in main context without affecting UI
* Save in background in a NSOperationQueue


## Get Started

### Install LFSCoreData using CocoaPods

Podfile

	platform :ios, '7.0'
	pod 'LFSCoreData', '~> 1.0'

### Setup

Before starting using LFSCoreData you should read this patterns, and create your entities in xcdatamodel:

[Setup your project using LFCoreDataPatterns](https://github.com/lafosca/LFSCoreData/wiki/Setup-your-entities-using-LFSCoreData-patterns)	

## Usage

### Import one object

	NSDictionary *object = @{ name: @"Son", surname: @"Goku" };
	User *user = [User importObject:object inContext:[[LFDataModel sharedModel] mainContext]]; 
	
	// Save context to be persistent
	[[LFDataModel sharedModel] saveContext];

### Basic import array using AFNetworking

	...

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [Tweet importFromArray:JSON[@"results"] inContext:[[LFDataModel sharedModel]mainContext]];
        
        // Save context to be persistent
		[[LFDataModel sharedModel] saveContext];
		
        [self updateTweetsInUI];
        
    } failure:nil];
    
	...


### Import array in background

	...

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    
	    [LFSaveInBackgroundOperation saveInBackgroundWithBlock:^(NSManagedObjectContext *backgroundContext) {
    	    	[Tweet importFromArray:JSON[@"results"] inContext:backgroundContext];   
    	    	
    	    	//Save in background already executes save method, so here is not necessary 
   	    } completion:^{
   	            [self updateTweetsInUI];
   	    }];
        
        [self updateTweetsInUI];
        
    } failure:nil];
    
	…
	
### Complex imports in background

	...

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    
	    [LFSaveInBackgroundOperation saveInBackgroundWithBlock:^(NSManagedObjectContext *backgroundContext) {
	    
		    Tweet *tweet = [Event objectForIdentifier:JSON[@"id"] 
					 		   inManagedObjectContext:backgroundContext
			  						    forEntityName:[Tweet entityName]];
		    
		    if (!tweet){
		        tweet = [Tweet insertInManagedObjectContext:backgroundContext];
		    }
		    tweet.tweetID = JSON[@"id"];
		    tweet.name =  [JSON[@"name"] uppercaseString];
		    
		    
   	    } completion:^{
   	            [self updateTweetsInUI];
   	    }];
        
        [self updateTweetsInUI];
        
    } failure:nil];
    
	…

## Sync objects from array

This way you can delete all the elements in the database of the importing entity, except the ones you are importing now.

Can be useful when using LFSCoreData as a cache of your data and this data is volatile.

The usage is like this:

    [Tweet importFromArray:yourArrayOfNewObjects
                 inContext:[[LFSDataModel sharedModel] mainContext]
        deleteOtherObjects:YES];

## Delete all objects of an entity

Now you can delete all objects for an specific entity like this:

    [Tweet deleteAllObjects];
    
## Author

LAFOSCA STUDIO S.L.

## License

LFSCoreData is available under the MIT license. See the LICENSE file for more info.

