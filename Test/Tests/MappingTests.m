#import "Kiwi.h"

#import <AFNetworking/AFNetworking.h>
#import <LFSCoreData/LFSCoreData.h>
#import "Tweet.h"
#import "User.h"

SPEC_BEGIN (MappingTests)

context(@"LFCoreData", ^{
    
    beforeEach(^{
        [[LFSDataModel sharedModel] activateTestDB];
    });
    
    afterAll(^{
        [[LFSDataModel sharedModel] cleanTestDatabase];
    });
    
    afterEach(^{
        [[LFSDataModel sharedModel] saveContextAndWait];
    });
    
    describe(@"Mapping", ^{
        
        __block NSArray *tweets;
        __block NSManagedObjectContext *mainContext;
        
        beforeEach(^{
            NSDictionary *firstTweet = @{
                                         @"text" : @"Lorem ipsum dolor",
                                         @"created_at" : @"Fri, 15 Feb 2013 10:45:15 +0000",
                                         @"user" : @{
                                                 @"id" : @123,
                                                 @"name" : @"lafosca",
                                                 @"screen_name" : @"lafosca"
                                                 },
                                         @"id" : @1234568
                                         };
            
            NSDictionary *secondTweet = @{
                                          @"text" : @"Lorem ipsum dolor 2",
                                          @"created_at" : @"Fri, 15 Feb 2013 10:45:15 +0000",
                                          @"user" : @{
                                                  @"id" : @123,
                                                  @"name" : @"lafosca",
                                                  @"screen_name" : @"lafosca"
                                                  },
                                          @"id" : @1234567
                                          };
            NSDictionary *thirdTweet = @{
                                          @"text" : @"Lorem ipsum dolor 2",
                                          @"created_at" : @"Fri, 15 Feb 2013 10:45:15 +0000",
                                          @"user" : @{
                                                  @"id" : @123,
                                                  @"name" : @"lafosca",
                                                  @"screen_name" : @"lafosca"
                                                  },
                                          @"id" : @1234566
                                          };
            NSDictionary *fourthTweet = @{
                                          @"text" : @"Lorem ipsum dolor 2",
                                          @"created_at" : @"Fri, 15 Feb 2013 10:45:15 +0000",
                                          @"user" : @{
                                              @"id" : @123,
                                              @"name" : @"lafosca",
                                              @"screen_name" : @"lafosca"
                                          },
                                          @"id" : @1234565
                                          };
            
            
            NSArray *results = @[firstTweet, secondTweet,thirdTweet,fourthTweet];
            
            mainContext = [[LFSDataModel sharedModel] mainContext];
            tweets = [Tweet importFromArray:results inContext:mainContext];
            [[LFSDataModel sharedModel] saveContext];
        });
        
        it(@"should map text of a tweet", ^{
            Tweet *tweet = [tweets objectAtIndex:0];
            
            [[tweet.text should] equal:@"Lorem ipsum dolor"];
        });

        it(@"should map date of a tweet", ^{
            Tweet *tweet = [tweets objectAtIndex:0];
            
            [[tweet created_at] shouldNotBeNil];
        });
        
        it(@"should map identifier of a tweet", ^{
            Tweet *tweet = [tweets objectAtIndex:0];
            
            [[[tweet tweetID] should] equal:@1234568];
        });
        
        it(@"should map relationships like user", ^{
            Tweet *tweet = [tweets objectAtIndex:3];
            
            [[[tweet.user screen_name] should] equal:@"lafosca"];
        });
        
        it (@"should use old instances and not make repeated" , ^{
            
            NSDictionary *repeatedTweet = @{
                                          @"text" : @"Lorem ipsum dolor 2",
                                          @"created_at" : @"Fri, 15 Feb 2013 10:45:15 +0000",
                                          @"user" : @{
                                                  @"id" : @123,
                                                  @"name" : @"lafosca",
                                                  @"screen_name" : @"lafosca"
                                                  },
                                          @"id" : @1234565
                                          };
            
            mainContext = [[LFSDataModel sharedModel] mainContext];
            tweets = [Tweet importObject:repeatedTweet inContext:mainContext];
            [[LFSDataModel sharedModel] saveContext];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[Tweet entityName]];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tweetID == \"1234565\""]];
            
            int objectCount = [mainContext countForFetchRequest:fetchRequest error:nil];
            [[@(objectCount) should] equal:@1];
        });
        
        it(@"maps key-path objects", ^{
            NSDictionary *user = @{
                                        @"id" : @123,
                                        @"name" : @"lafosca",
                                        @"screen_name" : @"lafosca",
                                        @"image" : @{
                                                @"thumbnail": @{
                                                        @"url": @"http://example.com"
                                                        }
                                                }
                                        };
            User *userObj = [User importObject:user inContext:[[LFSDataModel sharedModel]mainContext]];
            [[userObj.image_url should] equal:@"http://example.com"];
        });
        
        it(@"maps recursive relationships", ^{
            NSDictionary *tweet = @{
                                            @"text" : @"Lorem ipsum dolor 2",
                                            @"created_at" : @"Fri, 15 Feb 2013 10:45:15 +0000",
                                            @"user" : @{
                                                    @"id" : @123,
                                                    @"name" : @"lafosca",
                                                    @"screen_name" : @"lafosca",
                                                    @"lastStatus" : @{
                                                            @"text" : @"last status text",
                                                            @"created_at" : @"Fri, 15 Feb 2013 10:45:15 +0000",
                                                            @"id" : @12345661234
                                                            },
                                                    },
                                            @"id" : @1234565
                                            };
            
            Tweet *tweetObj = [Tweet importObject:tweet inContext:mainContext];
            [[[[[tweetObj user] lastStatus] text] should] equal: @"last status text"];
        });
        
        it(@"should map relationships by multiple identifiers", ^{
            __block Tweet *tweet;
            
            [LFSSaveInBackgroundOperation saveInBackgroundWithBlock:^(NSManagedObjectContext *backgroundContext) {
                NSDictionary *retweeter = @{
                                       @"id" : @123,
                                       @"name" : @"lafosca",
                                       @"screen_name" : @"lafosca"
                                       };
                
                [User importObject:retweeter inContext:backgroundContext];
                
                NSDictionary *anotherRetweeter = @{
                                       @"id" : @124,
                                       @"name" : @"lafosca",
                                       @"screen_name" : @"lafosca"
                                       };
                
                [User importObject:anotherRetweeter inContext:backgroundContext];
                
            } completion:^{
                [LFSSaveInBackgroundOperation saveInBackgroundWithBlock:^(NSManagedObjectContext *backgroundContext) {
                    NSDictionary *firstTweet = @{
                                                 @"text" : @"Lorem ipsum dolor",
                                                 @"created_at" : @"Fri, 15 Feb 2013 10:45:15 +0000",
                                                 @"retweeters" : @[@"123", @"124"],
                                                 @"id" : @1234568988
                                                 };
                    
                    [Tweet importFromArray:@[firstTweet] inContext:backgroundContext];
                    [[LFSDataModel sharedModel] saveContext];
                } completion:^{
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[Tweet entityName]];
                    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tweetID == \"1234568988\""]];
                    
                    NSArray *tweets = [[[LFSDataModel sharedModel] mainContext] executeFetchRequest:fetchRequest error:nil];
                    tweet = [tweets objectAtIndex:0];
                }];
            }];
            
            [[expectFutureValue(theValue([[tweet.retweeters allObjects] count])) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:theValue(2)];

            
        });
        it(@"should map relationships by identifiers", ^{
            __block Tweet *tweet;
            
            [LFSSaveInBackgroundOperation saveInBackgroundWithBlock:^(NSManagedObjectContext *backgroundContext) {
                NSDictionary *user = @{
                                       @"id" : @123,
                                       @"name" : @"lafosca",
                                       @"screen_name" : @"lafosca"
                                       };
                
                [User importObject:user inContext:backgroundContext];

            } completion:^{
                [LFSSaveInBackgroundOperation saveInBackgroundWithBlock:^(NSManagedObjectContext *backgroundContext) {
                    NSDictionary *firstTweet = @{
                                                 @"text" : @"Lorem ipsum dolor",
                                                 @"created_at" : @"Fri, 15 Feb 2013 10:45:15 +0000",
                                                 @"user_id" : @123,
                                                 @"id" : @1234568988
                                                 };
                    
                    [Tweet importFromArray:@[firstTweet] inContext:backgroundContext];
                    [[LFSDataModel sharedModel] saveContext];
                } completion:^{
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[Tweet entityName]];
                    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tweetID == \"1234568988\""]];
                    
                    NSArray *tweets = [[[LFSDataModel sharedModel] mainContext] executeFetchRequest:fetchRequest error:nil];
                    tweet = [tweets objectAtIndex:0];
                }];
            }];
            
            [[expectFutureValue([tweet.user screen_name]) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:@"lafosca"];

            
        });
        it(@"should map one-to-many relationships by identifiers", ^{
            __block User *user;
            
            [LFSSaveInBackgroundOperation saveInBackgroundWithBlock:^(NSManagedObjectContext *backgroundContext) {
                NSDictionary *firstTweet = @{
                                             @"text" : @"Lorem ipsum dolor",
                                             @"created_at" : @"Fri, 15 Feb 2013 10:45:15 +0000",
                                             @"user_id" : @124,
                                             @"id" : @1234568985
                                             };
                NSDictionary *secondTweet = @{
                                             @"text" : @"Lorem ipsum dolor",
                                             @"created_at" : @"Fri, 15 Feb 2013 10:45:15 +0000",
                                             @"user_id" : @124,
                                             @"id" : @1234568984
                                             };
                NSDictionary *user = @{
                                       @"id" : @124,
                                       @"name" : @"lafosca",
                                       @"screen_name" : @"lafosca",
                                       @"tweets" : @[firstTweet,secondTweet]
                                       };
                
                [User importObject:user inContext:backgroundContext];
            } completion:^{
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[User entityName]];
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"userID == 124"]];
                
                NSArray *users = [[[LFSDataModel sharedModel] mainContext] executeFetchRequest:fetchRequest error:nil];
                user = [users objectAtIndex:0];
            }];
            
            [[expectFutureValue(theValue(user.tweets.count)) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:theValue(2)];
        });
        
        it(@"should delete old objects when importing from arra, if needed", ^{
            NSDictionary *firstTweet = @{
                                         @"text" : @"Lorem ipsum dolor 1",
                                         @"id" : @1234568985
                                         };
            NSDictionary *secondTweet = @{
                                          @"text" : @"Lorem ipsum dolor 2",
                                          @"id" : @1234568984
                                          };
            
            [Tweet importFromArray:@[firstTweet, secondTweet] inContext:[[LFSDataModel sharedModel] mainContext]];
           
            NSDictionary *twirdTweet = @{
                                          @"text" : @"Lorem ipsum dolor 3",
                                          @"id" : @1234568983
                                          };
            
            [Tweet importFromArray:@[firstTweet, twirdTweet]
                                            inContext:[[LFSDataModel sharedModel] mainContext]
                                   deleteOtherObjects:YES];
            
            NSFetchRequest *fetchforDeletedObject = [[NSFetchRequest alloc] initWithEntityName:[Tweet entityName]];
            [fetchforDeletedObject setPredicate:[NSPredicate predicateWithFormat:@"tweetID = %@", @1234568984]];
            NSUInteger count = [[[LFSDataModel sharedModel] mainContext] countForFetchRequest:fetchforDeletedObject error:nil];
            [[theValue(count) should] equal:theValue(0)];
        });
        
        it(@"should work with nil completion", ^{
            [LFSSaveInBackgroundOperation saveInBackgroundWithBlock:^(NSManagedObjectContext *backgroundContext) {
                NSDictionary *firstTweet = @{
                                             @"text" : @"Lorem ipsum dolor",
                                             @"created_at" : @"Fri, 15 Feb 2013 10:45:15 +0000",
                                             @"user_id" : @124,
                                             @"id" : @1234568985
                                             };
                NSDictionary *secondTweet = @{
                                              @"text" : @"Lorem ipsum dolor",
                                              @"created_at" : @"Fri, 15 Feb 2013 10:45:15 +0000",
                                              @"user_id" : @124,
                                              @"id" : @1234568984
                                              };
                NSDictionary *user = @{
                                       @"id" : @124,
                                       @"name" : @"lafosca",
                                       @"screen_name" : @"lafosca",
                                       @"tweets" : @[firstTweet,secondTweet]
                                       };
                
                [User importObject:user inContext:backgroundContext];
            } completion:nil];
        });
    });
});

SPEC_END


