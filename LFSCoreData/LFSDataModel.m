//  LFSDataModel.m
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

#import "LFSDataModel.h"

@interface LFSDataModel()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, assign) BOOL test;


- (NSString *)documentsDirectory;

@end

@implementation LFSDataModel

@synthesize mainContext = _mainContext;
@synthesize privateContext = _privateContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (LFSDataModel *)sharedModel {
    static LFSDataModel *_sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[LFSDataModel alloc] init];
    });
    
    return _sharedModel;
}

- (void) activateTestDB
{
    _persistentStoreCoordinator = nil;
    _mainContext = nil;
    _privateContext = nil;
    _managedObjectModel = nil;
    self.test = YES;
}

- (void)addBackgroundOperation:(NSOperation *)operation
{
    if (!self.backgroundQueue){
        self.backgroundQueue = [[NSOperationQueue alloc] init];
        [self.backgroundQueue setMaxConcurrentOperationCount:1];
    }
    
    [self.backgroundQueue addOperation:operation];
}

- (void) cleanTestDatabase
{
    _persistentStoreCoordinator = nil;
    _mainContext = nil;
    NSError *error;
    NSURL *storeURL = [NSURL fileURLWithPath:[self pathToLocalStore]];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    self.test = NO;
}

-(NSString *)modelName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

-(NSString *)pathToModel
{
    return [[[NSBundle mainBundle] pathsForResourcesOfType:@"momd" inDirectory:nil] objectAtIndex:0];
}

-(NSString *)pathToLocalStore
{
    return [[self documentsDirectory] stringByAppendingPathComponent:[self storeFilename]];
}

-(NSString *)storeFilename
{
    if (!self.test){
        return [[self modelName] stringByAppendingPathExtension:@"sqlite"];
    } else {
        return [@"test" stringByAppendingPathExtension:@"sqlite"];
    }
}
-(NSString *)documentsDirectory
{
    NSString *documentsDirectory = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSManagedObjectContext *)mainContext {
    if (_mainContext == nil) {
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setParentContext:[self privateContext]];
    }
    
    return _mainContext;
}

- (NSManagedObjectContext *)privateContext {
    if (_privateContext == nil) {
        _privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _privateContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
    }
    
    return _privateContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        NSURL *storeURL = [NSURL fileURLWithPath:[self pathToModel]];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:storeURL];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        NSLog(@"SQLITE STORE PATH: %@", [self pathToLocalStore]);
        NSURL *storeURL = [NSURL fileURLWithPath:[self pathToLocalStore]];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]
                                             initWithManagedObjectModel:[self managedObjectModel]];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        NSError *e = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:options
                                       error:&e]) {
            
            BOOL shouldRemoveDataFile = YES;
            if ([self.delegate respondsToSelector:@selector(shouldRemoveAllDataWhenVersionConflicts)]){
                shouldRemoveDataFile = [self.delegate shouldRemoveAllDataWhenVersionConflicts];
            }
            if (shouldRemoveDataFile){
                [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
                [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
                if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                                       configuration:nil
                                                 URL:storeURL
                                             options:options
                                               error:&e]) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:e forKey:NSUnderlyingErrorKey];
                    NSString *reason = @"Could not create persistent store.";
                    NSException *exc = [NSException exceptionWithName:NSInternalInconsistencyException
                                                               reason:reason
                                                             userInfo:userInfo];
                    
                    @throw exc;
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LFCoreDataMigrationDidFailed" object:nil];
            NSLog(@"LFCoreDataMigrationDidFailed");
        }
        
        _persistentStoreCoordinator = psc;
    }
    
    return _persistentStoreCoordinator;
}

- (void)saveContext
{
    [self saveContext:NO];
}

- (void)saveContextAndWait
{
    [self saveContext:YES];
}

- (void)saveContext:(BOOL)wait
{
    if ([[self mainContext] hasChanges]){
        [[self mainContext] performBlockAndWait:^{
            NSError *error;
            [[self mainContext] save:&error];
            if (error){
                NSLog(@"Error saving main context %@",error);
            }
        }];
    }
    
    void (^savePrivate)() = ^{
        NSError *error;
        [[self privateContext] save:&error];
        if (error){
            NSLog(@"Error saving changes to disk %@",error);
        }
    };
    
    if ([[self privateContext] hasChanges]){
        if (wait){
            [[self privateContext] performBlockAndWait:savePrivate];
        } else {
            [[self privateContext] performBlock:savePrivate];
        }
    }
}

- (void) resetPersistantStore
{
    _persistentStoreCoordinator = nil;
    _mainContext = nil;
    _privateContext = nil;
    NSError *error;
    NSURL *storeURL = [NSURL fileURLWithPath:[self pathToLocalStore]];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    if (error){
        NSLog(@"%@",error);
    }
    
}

@end
