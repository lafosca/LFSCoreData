// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>


extern const struct UserAttributes {
	__unsafe_unretained NSString *image_url;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *screen_name;
	__unsafe_unretained NSString *userID;
} UserAttributes;

extern const struct UserRelationships {
	__unsafe_unretained NSString *lastStatus;
	__unsafe_unretained NSString *tweets;
} UserRelationships;

extern const struct UserFetchedProperties {
} UserFetchedProperties;

@class Tweet;
@class Tweet;






@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (UserID*)objectID;





@property (nonatomic, strong) NSString* image_url;



//- (BOOL)validateImage_url:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* screen_name;



//- (BOOL)validateScreen_name:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* userID;



@property int32_t userIDValue;
- (int32_t)userIDValue;
- (void)setUserIDValue:(int32_t)value_;

//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Tweet *lastStatus;

//- (BOOL)validateLastStatus:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *tweets;

- (NSMutableSet*)tweetsSet;





@end

@interface _User (CoreDataGeneratedAccessors)

- (void)addTweets:(NSSet*)value_;
- (void)removeTweets:(NSSet*)value_;
- (void)addTweetsObject:(Tweet*)value_;
- (void)removeTweetsObject:(Tweet*)value_;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveImage_url;
- (void)setPrimitiveImage_url:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveScreen_name;
- (void)setPrimitiveScreen_name:(NSString*)value;




- (NSNumber*)primitiveUserID;
- (void)setPrimitiveUserID:(NSNumber*)value;

- (int32_t)primitiveUserIDValue;
- (void)setPrimitiveUserIDValue:(int32_t)value_;





- (Tweet*)primitiveLastStatus;
- (void)setPrimitiveLastStatus:(Tweet*)value;



- (NSMutableSet*)primitiveTweets;
- (void)setPrimitiveTweets:(NSMutableSet*)value;


@end
