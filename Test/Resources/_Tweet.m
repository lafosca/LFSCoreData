// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tweet.m instead.

#import "_Tweet.h"

const struct TweetAttributes TweetAttributes = {
	.created_at = @"created_at",
	.text = @"text",
	.tweetID = @"tweetID",
};

const struct TweetRelationships TweetRelationships = {
	.retweeters = @"retweeters",
	.user = @"user",
};

const struct TweetFetchedProperties TweetFetchedProperties = {
};

@implementation TweetID
@end

@implementation _Tweet

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Tweet";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:moc_];
}

- (TweetID*)objectID {
	return (TweetID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"tweetIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"tweetID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic created_at;






@dynamic text;






@dynamic tweetID;



- (int32_t)tweetIDValue {
	NSNumber *result = [self tweetID];
	return [result intValue];
}

- (void)setTweetIDValue:(int32_t)value_ {
	[self setTweetID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTweetIDValue {
	NSNumber *result = [self primitiveTweetID];
	return [result intValue];
}

- (void)setPrimitiveTweetIDValue:(int32_t)value_ {
	[self setPrimitiveTweetID:[NSNumber numberWithInt:value_]];
}





@dynamic retweeters;

	
- (NSMutableSet*)retweetersSet {
	[self willAccessValueForKey:@"retweeters"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"retweeters"];
  
	[self didAccessValueForKey:@"retweeters"];
	return result;
}
	

@dynamic user;

	






@end
