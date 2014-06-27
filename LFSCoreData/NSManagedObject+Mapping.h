//
//  NSManagedObject+Mapping.h
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


#import <CoreData/CoreData.h>
#import "NSDate+Extras.h"
/**
 This category adds mapping methods to an NSManagedObject to use it with an external API automatically
 */

@interface NSManagedObject (Mapping)

///---------------------------------------------
/// @name Accessing objects in the database
///---------------------------------------------

/**
 Returns the object with the identifier given by parameter.
 
 @param identifier Primary-key used to fetch the object
 @param moc NSManagedObjectContext that will be used to manage the object
 @param entityName Name of the entity that will be mapped. Usually used [Model entityName].
 
 @return Object fetched in core data
 */

+ (id)objectForIdentifier:(id)identifier inManagedObjectContext:(NSManagedObjectContext *)moc forEntityName:(NSString *)entityName;

///---------------------------------------------
/// @name Importing object to the Core Data Database
///---------------------------------------------

/**
 Import an object and its relationships to core data. The object that you will be mapping should be with the same name in xcdatamodel as it has in the API service. You should call this method with the class that you are importing.
 
 @param dictionary Dictionary with the information that will be mapped to the current object
 @param context Context that will save the object
 
 @return Object created in core data with attributes
 */

+ (id)importObject:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context;

/**
 Import objects from an array. See `importObject:inContext:` to see more details.
 
 @param objects Import objects in an array using `importObject:inContext:` method.
 @param context Context that will save the objects
 
 */
+ (NSArray *)importFromArray:(NSArray *)objects inContext:(NSManagedObjectContext *)context;


/**
 Import objects from an array. See `importObject:inContext:` to see more details.
 
 @param objects Import objects in an array using `importObject:inContext:` method.
 @param context Context that will save the objects
 @param deleteOther When YES will erase of the database all the objects not contained in the array
 
 */
+ (NSArray *)importFromArray:(NSArray *)objects inContext:(NSManagedObjectContext *)context deleteOtherObjects:(BOOL)deleteOther;

///---------------------------------------------
/// @name Mapping dictionaries to NSManagedObjects
///---------------------------------------------

/**
 Map Attributes for a given object
 
 @param dictionary Dictionary with the information that will be mapped to the current object
 @param moc NSManagedObjectContext that will be used to manage the object
 @param entityName Name of the entity that will be mapped. Usually used [Model entityName].
 
 */
- (void)mapAttributtes:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)moc forEntityName:(NSString *)entityName;

///---------------------------------------------
/// @name Entity Information
///---------------------------------------------

/**
 Returns the object identifier name for a single instance
 
 @return String with the identifier name
 */
- (NSString *)identifierName;

@end
