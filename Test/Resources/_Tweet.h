// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tweet.h instead.

#import <CoreData/CoreData.h>


extern const struct TweetAttributes {
	__unsafe_unretained NSString *created_at;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *tweetID;
} TweetAttributes;

extern const struct TweetRelationships {
	__unsafe_unretained NSString *retweeters;
	__unsafe_unretained NSString *user;
} TweetRelationships;

extern const struct TweetFetchedProperties {
} TweetFetchedProperties;

@class User;
@class User;





@interface TweetID : NSManagedObjectID {}
@end

@interface _Tweet : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TweetID*)objectID;





@property (nonatomic, strong) NSDate* created_at;



//- (BOOL)validateCreated_at:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* tweetID;



@property int32_t tweetIDValue;
- (int32_t)tweetIDValue;
- (void)setTweetIDValue:(int32_t)value_;

//- (BOOL)validateTweetID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *retweeters;

- (NSMutableSet*)retweetersSet;




@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _Tweet (CoreDataGeneratedAccessors)

- (void)addRetweeters:(NSSet*)value_;
- (void)removeRetweeters:(NSSet*)value_;
- (void)addRetweetersObject:(User*)value_;
- (void)removeRetweetersObject:(User*)value_;

@end

@interface _Tweet (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreated_at;
- (void)setPrimitiveCreated_at:(NSDate*)value;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;




- (NSNumber*)primitiveTweetID;
- (void)setPrimitiveTweetID:(NSNumber*)value;

- (int32_t)primitiveTweetIDValue;
- (void)setPrimitiveTweetIDValue:(int32_t)value_;





- (NSMutableSet*)primitiveRetweeters;
- (void)setPrimitiveRetweeters:(NSMutableSet*)value;



- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
