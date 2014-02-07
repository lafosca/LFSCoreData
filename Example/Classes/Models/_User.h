// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>


extern const struct UserAttributes {
	__unsafe_unretained NSString *avatarImageURL;
	__unsafe_unretained NSString *userID;
	__unsafe_unretained NSString *username;
} UserAttributes;

extern const struct UserRelationships {
	__unsafe_unretained NSString *posts;
} UserRelationships;

extern const struct UserFetchedProperties {
} UserFetchedProperties;

@class Post;





@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (UserID*)objectID;





@property (nonatomic, strong) NSString* avatarImageURL;



//- (BOOL)validateAvatarImageURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* userID;



//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* username;



//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *posts;

- (NSMutableSet*)postsSet;





@end

@interface _User (CoreDataGeneratedAccessors)

- (void)addPosts:(NSSet*)value_;
- (void)removePosts:(NSSet*)value_;
- (void)addPostsObject:(Post*)value_;
- (void)removePostsObject:(Post*)value_;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAvatarImageURL;
- (void)setPrimitiveAvatarImageURL:(NSString*)value;




- (NSString*)primitiveUserID;
- (void)setPrimitiveUserID:(NSString*)value;




- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;





- (NSMutableSet*)primitivePosts;
- (void)setPrimitivePosts:(NSMutableSet*)value;


@end
