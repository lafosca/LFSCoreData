
//  NSManagedObject+Mapping.m
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

#import "NSManagedObject+Mapping.h"
#import "LFSDataModel.h"

@implementation NSManagedObject (Mapping)

- (void) mapAttributtes:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)moc forEntityName:(NSString *)entityName
{
    NSEntityDescription *activityEntity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    
    NSDictionary *attributes = [activityEntity attributesByName];
    
    for (NSString *key in attributes) {
        NSAttributeDescription *attribute = [attributes objectForKey:key];
        NSString *keyPath = [[attribute userInfo] objectForKey:@"mappingPath"];
        
        NSString *value;
        
        if (!keyPath){
            value = [dictionary objectForKey:key];
        } else {
            value = [dictionary valueForKeyPath:keyPath];
        }
        
        if (![key isEqualToString:@"id"] &&
            ([value isKindOfClass:[NSString class]] ||
             [value isKindOfClass:[NSNumber class]])) {
                if ([[attribute attributeValueClassName] isEqualToString:@"NSDate"]){
                    NSString *format = [[attribute userInfo] objectForKey:@"dateFormat"];
                    NSDate *date;
                    
                    if (format){
                        date = [NSDate dateFromString:value format:format];
                    } else if( [value isKindOfClass:[NSNumber class]]) {
                        date = [NSDate dateWithTimeIntervalSince1970:[value intValue]];
                    } else {
                        date = [NSDate dateFromString:value];
                    }
                    
                    [self setValue:date forKey:key];
                } else if (attribute){
                    [self setValue:value forKey:key];
                }
                
            } else if ([key isEqualToString:[[self class] identifierForEntityName:[[self class] entityName]]]){
                NSString *value = [dictionary objectForKey:@"id"];
                
                if ([value isKindOfClass:[NSString class]]){
                    [self setValue:value forKey:[NSManagedObject identifierForEntityName:entityName]];
                } else if ([value isKindOfClass:[NSNumber class]]){
                    [self setValue:value forKey:[NSManagedObject identifierForEntityName:entityName]];
                } else {
                    [self setValue:value.description forKey:[NSManagedObject identifierForEntityName:entityName]];
                }
            } else if ([value isKindOfClass:[NSNull class]]){
                [self setValue:nil forKey:key];
            }
    }
}

- (void) mapRelationships:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)moc forEntityName:(NSString *)entityName
{
    NSEntityDescription *activityEntity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    
    NSDictionary *relationships = [activityEntity relationshipsByName];
    
    id relationshipArrayOfDictionaries;
    
    for (NSString *relationship in relationships) {
        id relationObject = nil;
        NSString *entityName = [[[relationships objectForKey:relationship] destinationEntity] name];
        NSAttributeDescription *relationshipInfo = [relationships objectForKey:relationship];
        id relationshipID = [self identifierForRelationshipInfo:relationshipInfo];
        if ([self isLazyRelationshipWithDictionary:dictionary andRelationshipID:relationshipID]){
            relationshipID = [dictionary objectForKey:relationshipID];
            
            if (relationshipID == [NSNull null]){
                [self setValue:nil forKey:relationship];
            }else{
                relationObject = [NSManagedObject objectForIdentifier:relationshipID inManagedObjectContext:moc forEntityName:entityName];
                if (!relationObject){
                    //We create a dummy object to access URL
                    relationObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:moc];
                    [relationObject setValue:relationshipID forKey:[relationObject identifierName]];
                }
            }
            
        } else if ([self isMultipleLazyRelationshipWithDictionary:dictionary andRelationshipName:relationship]) {
            NSArray *relationshipArrayOfIdentifiers= [dictionary objectForKey:relationship];
            for (NSString *identifier in relationshipArrayOfIdentifiers) {
                id relationSingleObject = [NSManagedObject objectForIdentifier:identifier inManagedObjectContext:moc forEntityName:entityName];
                if (!relationSingleObject) {
                    relationSingleObject = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:moc] insertIntoManagedObjectContext:moc];
                    [relationSingleObject setValue:identifier forKey:[relationSingleObject identifierName]];
                }
                NSMutableSet *relationshipset = [NSMutableSet setWithSet:[self valueForKey:relationship]];
                [relationshipset addObject:relationSingleObject];
                relationObject = [NSSet setWithSet:relationshipset];
                [self setValue:relationObject forKey:relationship];
            }
        } else if ([self isFullSingleRelationshipWithDictionary:dictionary andRelationshipName:relationship]) {
            NSDictionary *relationshipDictionary = [dictionary objectForKey:relationship];;
            if (relationshipDictionary){
                relationObject = [[self class] importObject:relationshipDictionary inContext:moc inObject:nil mapRelationships:YES forEntityName:entityName forceInsert:NO];
            }
            
        } else if ([self isFullMultipleRelationshipWithDictinary:dictionary andRelationshipName:relationship]) {
            relationshipArrayOfDictionaries = [dictionary objectForKey:relationship];
            for (NSDictionary *relationshipDictionary in relationshipArrayOfDictionaries) {
                if (relationshipDictionary){
                    id relationSingleObject = [[self class] importObject:relationshipDictionary inContext:moc inObject:nil mapRelationships:YES forEntityName:entityName forceInsert:NO];
                    NSMutableSet *relationshipset = [NSMutableSet setWithSet:[self valueForKey:relationship]];
                    [relationshipset addObject:relationSingleObject];
                    relationObject = [NSSet setWithSet:relationshipset];
                    [self setValue:relationObject forKey:relationship];
                }
            }
        } else {
            relationObject = nil;
        }
        if (relationObject) [self setValue:relationObject forKey:relationship];
    }
}

- (BOOL)isLazyRelationshipWithDictionary:(NSDictionary *)dictionary andRelationshipID:(NSString *)identifier {
    return [[dictionary allKeys] containsObject:identifier];
}

- (NSString *)identifierForRelationshipInfo:(NSAttributeDescription *)relationshipInfo
{
    NSString *keyPath = [[relationshipInfo userInfo] objectForKey:@"mappingPath"];
    NSString *key = [NSString stringWithFormat:@"%@_id",relationshipInfo.name];
    if (keyPath){
        key = keyPath;
    }
    return key;
}

- (BOOL)isMultipleLazyRelationshipWithDictionary:(NSDictionary *)dictionary andRelationshipName:(NSString *)relationshipName {
    //We check if this is an array not null of strings
    id value = [dictionary objectForKey:[NSString stringWithFormat:@"%@",relationshipName]];
    if (!value) return NO;
    BOOL isArray = [value isKindOfClass:[NSArray class]];
    
    if (isArray){
        NSArray *valueArray = (NSArray *)value;
        if (valueArray.count > 0){
            id valueOfItem = [valueArray objectAtIndex:0];
            if ([valueOfItem isKindOfClass:[NSString class]]){
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    }
    
    return NO;
}
- (BOOL)isFullSingleRelationshipWithDictionary:(NSDictionary *)dictionary andRelationshipName:(NSString *)relationshipName {
    BOOL result = [[dictionary objectForKey:[NSString stringWithFormat:@"%@",relationshipName]] isKindOfClass:[NSDictionary class]];
    return result;
}
- (BOOL)isFullMultipleRelationshipWithDictinary:(NSDictionary *)dictionary andRelationshipName:(NSString *)relationshipName {
    //We check if this is an array not null of dictionaries
    id value = [dictionary objectForKey:[NSString stringWithFormat:@"%@",relationshipName]];
    if (!value) return NO;
    BOOL isArray = [value isKindOfClass:[NSArray class]];
    
    if (isArray){
        NSArray *valueArray = (NSArray *)value;
        if (valueArray.count > 0){
            id valueOfItem = [valueArray objectAtIndex:0];
            if ([valueOfItem isKindOfClass:[NSDictionary class]]){
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    }
    
    return NO;
}

+ (NSString *)identifierForEntityName:(NSString *)entityName
{
    return [NSString stringWithFormat:@"%@ID", [entityName lowercaseString]];
}

- (NSString *)identifierName{
    return [NSString stringWithFormat:@"%@ID", [[[self class] entityName] lowercaseString]];
}

+ (NSString *) identifierClassInContext:(NSManagedObjectContext *)context
{
//    NSEntityDescription *activityEntity = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context];
//    
//    NSDictionary *attributes = [activityEntity attributesByName];
//    
//    NSAttributeDescription *attribute = [attributes objectForKey:[self identifierForEntityName:[self entityName]]];
    
    return @"NSString";
}

+ (NSString *)entityName
{
    return NSStringFromClass(self);
}

+ (id) objectForIdentifier:(id)identifier inManagedObjectContext:(NSManagedObjectContext *)moc forEntityName:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:entityName];
    
    NSString *value;
    NSString *identifierName = [NSManagedObject identifierForEntityName:entityName];
    if([identifier isKindOfClass:[NSNumber class]]){
        value = [NSString stringWithFormat:@"%i",[(NSNumber*)identifier intValue]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF.%@ = %@", identifierName, [identifier description] ]]];
    }else{
        value = [NSString stringWithFormat:@"%@",(NSString*)identifier];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF.%@ = '%@'", identifierName, identifier]]];
    }
    
    [fetchRequest setFetchLimit:1];
    
    NSError *error;
    
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    
    if (error){
        NSLog(@"ERROR: %@",error);
    }
    
    if (results.count == 0){
        return nil;
    } else {
        return [results objectAtIndex:0];
    }
}

+ (NSArray *)objectsForIdentifiers:(NSArray *)ids inContext:(NSManagedObjectContext *)moc
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"SELF.%@ IN %@",[self identifierForEntityName:[self entityName]],ids]];
    
    return [moc executeFetchRequest:fetchRequest error:nil];
}

+ (id)importObject:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context{
    return [self importObject:attributes inContext:context forceInsert:NO];
}
+ (id)importObject:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context forceInsert:(BOOL)forceInsert
{
    return [self importObject:attributes inContext:context inObject:nil forceInsert:forceInsert];
}

+ (id) importObject:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context inObject:(id)objectInDatabase forceInsert:(BOOL)forceInsert
{
    NSString *entityName = NSStringFromClass(self);
    return [self importObject:attributes inContext:context inObject:objectInDatabase mapRelationships:YES forEntityName:entityName forceInsert:forceInsert];
}

+ (id) importObject:(NSDictionary *)attributes
          inContext:(NSManagedObjectContext *)context
           inObject:(id)objectInDatabase
   mapRelationships:(BOOL)mapRelationships
      forEntityName:(NSString *)entityName
        forceInsert:(BOOL)forceInsert
{
    NSString* idString = [self idStringForEntityName:entityName
                                           inContext:context];
    
    id object;
    // TODO: Check if ID is the correct way to get the object.
    
    if (forceInsert){
        object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    } else {
        if (!objectInDatabase){
            object = [NSManagedObject objectForIdentifier:[attributes valueForKeyPath:idString] inManagedObjectContext:context forEntityName:entityName];
            
            if (!object){
                object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
            }
        } else {
            object = objectInDatabase;
        }
    }
    
    [object mapAttributtes:attributes inContext:context forEntityName:entityName];
    if (mapRelationships) [object mapRelationships:attributes inContext:context forEntityName:entityName];
    
    return object;
}
+ (NSArray *)importFromArray:(NSArray *)objects inContext:(NSManagedObjectContext *)context{
    return [self importFromArray:objects inContext:context forceInsert:NO];
}

+ (NSArray *)importFromArray:(NSArray *)objects inContext:(NSManagedObjectContext *)context forceInsert:(BOOL)forceInsert
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    for (NSDictionary *object in objects) {
        [results addObject:[self importObject:object inContext:context forceInsert:(BOOL)forceInsert]];
    }
    
    return results;
    
}

+ (NSArray *)importFromArray:(NSArray *)objects inContext:(NSManagedObjectContext *)context deleteOtherObjects:(BOOL)deleteOther {
    NSArray *importResultObjects = [self importFromArray:objects inContext:context];
    
    NSString *entityName = NSStringFromClass(self);
    NSFetchRequest *allEventsRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSString *identifierName = [NSManagedObject identifierForEntityName:entityName];
    
    NSArray *identifiers = [importResultObjects valueForKey:identifierName];
    
    [allEventsRequest setPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF.%@ IN %@)",identifierName,identifiers]];
    [allEventsRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    [allEventsRequest setIncludesPendingChanges:NO];
    
    NSError *error = nil;
    NSArray *events = [context executeFetchRequest:allEventsRequest error:&error];
    if (error){
        NSLog(@"ERROR on fetch request %@",error);
    }
    for (NSManagedObject *event in events) {
        [context deleteObject:event];
    }
    
    return importResultObjects;
}

+ (NSString*)idStringForEntityName:(NSString*)entityName inContext:(NSManagedObjectContext*)context{
    NSEntityDescription *activityEntity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSString *IDString = [[[[activityEntity attributesByName] valueForKey:[NSString stringWithFormat:@"%@ID", [entityName lowercaseString]]] userInfo] objectForKey:@"mappingPath"];
    
    if (!IDString) {
        IDString = @"id";
    }
    
    return IDString;
    
}

@end
