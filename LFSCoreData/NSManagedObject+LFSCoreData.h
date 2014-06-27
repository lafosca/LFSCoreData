//
//  NSManagedObject+LFSCoreData.h
//  Pods
//
//  Created by David Cortés Fulla on 20/02/14.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (LFSCoreData)

// Delete all objects and save it to the database for the caller class
+ (void) deleteAllObjects;

@end
