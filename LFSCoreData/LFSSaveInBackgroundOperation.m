//
//  LFSSaveInBackgroundOperation.m
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

#import "LFSSaveInBackgroundOperation.h"
#import "LFSDataModel.h"

@interface LFSSaveInBackgroundOperation()

@property (nonatomic, copy) void(^backgroundOperationsBlock)(NSManagedObjectContext *backgroundContext);
@property (nonatomic, copy) void(^completion)();

@end

@implementation LFSSaveInBackgroundOperation

- (void) enqueue
{
    [[LFSDataModel sharedModel] addBackgroundOperation:self];
}

+ (void) saveInBackgroundWithBlock:(void (^)(NSManagedObjectContext *backgroundContext))backgroundOperationsBlock
                      completion:(void(^)())completion
{
    LFSSaveInBackgroundOperation *saveOperation = [[LFSSaveInBackgroundOperation alloc] init];
    saveOperation.backgroundOperationsBlock = backgroundOperationsBlock;
    saveOperation.completion = completion;
    [saveOperation enqueue];
}

- (void) main
{
    //Create context
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] init];
    [backgroundContext setParentContext:[[LFSDataModel sharedModel] mainContext]];
    
    //Execute block
    self.backgroundOperationsBlock(backgroundContext);
    
    //Save
    NSError *error;
    [backgroundContext save:&error];
    if (error){
        NSLog(@"ERROR saving background context %@",error);
    }
    [[LFSDataModel sharedModel] saveContext];
    
    //Completion block in main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        self.completion();
    });
}

@end
