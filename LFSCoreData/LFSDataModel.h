//  LFSDataModel.h
//
//  Copyright (c) 2014 LAFOSCA STUDIO S.L.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 Data model delegate is the responsible of deleting core data sqlite file when a migration fails. If you don't want LFCoreData to delete it you should implement this in your AppDelegate and return NO in the `shouldRemoveAllDataWhenVersionConflicts` method.
 
 You also can use LFCoreDataMigrationDidFailed notification to control this issue.
 */

@protocol LFSDataModelDelegate <NSObject>

/** 
 Determine if the data model will be deleted when a conflict appears. Default value YES.
 */
- (BOOL) shouldRemoveAllDataWhenVersionConflicts;

@end

/**
 
LFSDataModel is a singleton wrapper to access all the stuff in Core Data. Here you have the mainContext (Main thread Context) and save operations (sync and async).
 
 */

@interface LFSDataModel : NSObject

/**
 Access the singleton instance
 */
+ (id) sharedModel;

/**
Main thread context
 */
@property (nonatomic, readonly) NSManagedObjectContext *mainContext;
/**
Background thread context
 */
@property (nonatomic, readonly) NSManagedObjectContext *privateContext;
/**
 Persistant Store Coordinator
 */
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
/**
 Persistant Store Coordinator
 */
@property (nonatomic, strong) id<LFSDataModelDelegate> delegate;
@property (nonatomic, strong) NSOperationQueue *backgroundQueue;

- (NSString *)modelName;
- (NSString *)pathToModel;
- (NSString *)storeFilename;
- (NSString *)pathToLocalStore;

/**
 Use this methods for testing with LFCoreData as a library
 */
- (void) activateTestDB;
- (void) cleanTestDatabase;

//Background operations
- (void)addBackgroundOperation:(NSOperation *)operation;

/**
 Save all contexts asynchronously. Use this when you update UI.
 
 */
- (void)saveContext __attribute__ ((deprecated));
- (void)saveContext:(NSError **)error;

/**
 Save all context syncronously. Use this when you are about to quit the application.
 
 */

- (void)saveContextAndWaitWithError:(NSError **)error;
- (void)saveContextAndWait __attribute__ ((deprecated));
/**
 Remove Sqlite file from the application
 
 */
- (void) resetPersistantStore;

@end
