//
//  NSManagedObject+LFSCoreData.m
//  Pods
//
//  Created by David Cortés Fulla on 20/02/14.
//
//

#import "NSManagedObject+LFSCoreData.h"
#import "LFSDataModel.h"

@implementation NSManagedObject (LFSCoreData)

+ (void) deleteAllObjects {
    [self deleteAllObjectsInContext:[[LFSDataModel sharedModel] mainContext]];
}

// Delete all objects for the given object in the given context
+ (void) deleteAllObjectsInContext:(NSManagedObjectContext *)context{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(self)];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if (error){
        NSLog(@"Error deleting all objects from %@", NSStringFromClass(self));
    }
    for (id object in objects) {
        [context deleteObject:object];
    }
    
    [[LFSDataModel sharedModel] saveContext];
}

@end
