// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Post.h instead.

#import <CoreData/CoreData.h>


extern const struct PostAttributes {
	__unsafe_unretained NSString *postID;
	__unsafe_unretained NSString *text;
} PostAttributes;

extern const struct PostRelationships {
	__unsafe_unretained NSString *user;
} PostRelationships;

extern const struct PostFetchedProperties {
} PostFetchedProperties;

@class User;




@interface PostID : NSManagedObjectID {}
@end

@interface _Post : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PostID*)objectID;





@property (nonatomic, strong) NSString* postID;



//- (BOOL)validatePostID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _Post (CoreDataGeneratedAccessors)

@end

@interface _Post (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitivePostID;
- (void)setPrimitivePostID:(NSString*)value;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;





- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
