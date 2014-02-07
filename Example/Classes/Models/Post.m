#import "Post.h"
#import "AFAppDotNetAPIClient.h"

@interface Post ()

// Private interface goes here.

@end


@implementation Post


+ (void)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    [[AFAppDotNetAPIClient sharedClient] getPath:@"stream/0/posts/stream/global" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        [LFSSaveInBackgroundOperation saveInBackgroundWithBlock:^(NSManagedObjectContext *backgroundContext) {
            [Post importFromArray:[JSON valueForKeyPath:@"data"] inContext:backgroundContext];
        } completion:^{
            NSArray *posts = [Post fetchPosts];
            if (block) {
                block(posts, nil);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

+ (NSArray *)fetchPosts {
   NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[Post entityName]];
   NSError *error;
   return [[[LFSDataModel sharedModel] mainContext] executeFetchRequest:fetchRequest error:&error];
}

@end
