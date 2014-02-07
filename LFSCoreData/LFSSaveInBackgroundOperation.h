//
//  LFSSaveInBackgroundOperation.h
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
 
 This child of NSOperation allows to you to save in background without problems of concurrent savings.
 
 */

 @interface LFSSaveInBackgroundOperation : NSOperation


///---------------------------------------------
/// @name Save in background
///---------------------------------------------

/**
 Executes a block asynchronously in a non-concurrent background operation. You can use this method to in the same model in differents places without having problems of integrity. It automatically save in background thread, and main context thread is updated.
 
 @param backgroundOperationsBlock Block that will be executed in background
 @param completion Block executed in the main thread when the operation of saving has been finished. You should fetch here your imported objects so you have it in the main thread managed object context.
 
 */

+ (void) saveInBackgroundWithBlock:(void (^)(NSManagedObjectContext *backgroundContext))backgroundOperationsBlock
                      completion:(void(^)())completion;


@end
