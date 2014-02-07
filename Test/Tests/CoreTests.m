#import "Kiwi.h"
#import "Tweet.h"
#import "User.h"

SPEC_BEGIN(CoreTests)

context(@"LFCoreData", ^{
    beforeEach(^{
        [[LFSDataModel sharedModel] activateTestDB];
    });
    
    afterEach(^{
        [[LFSDataModel sharedModel] saveContextAndWait];
        [[LFSDataModel sharedModel] cleanTestDatabase];
    });
    
    it(@"should save in background", ^{
        __block int count = 0;
        [LFSSaveInBackgroundOperation saveInBackgroundWithBlock:^(NSManagedObjectContext *backgroundContext) {
            NSDictionary *firstTweet = @{
                                         @"text" : @"Lorem ipsum dolor",
                                         @"created_at" : @"Fri, 15 Feb 2013 10:45:15 +0000",
                                         @"user" : @{
                                                 @"id" : @123,
                                                 @"name" : @"Lafosca Studio",
                                                 @"screen_name" : @"lafosca"
                                                 },
                                         @"id" : @1234568987
                                         };
            
            [Tweet importFromArray:@[firstTweet] inContext:backgroundContext];
            [[LFSDataModel sharedModel] saveContext];
        } completion:^{
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[Tweet entityName]];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tweetID == \"1234568987\""]];
            
            count = [[[LFSDataModel sharedModel] mainContext] countForFetchRequest:fetchRequest error:nil];
        }];
                
        [[expectFutureValue(theValue(count)) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:theValue(1)];
    });

});

SPEC_END