#import "_Post.h"

@interface Post : _Post {}

+ (NSArray *)fetchPosts;
+ (void)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
