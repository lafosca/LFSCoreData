//
//  ViewController.m
//  TwitterExampleCoreData
//
//  Created by David Cortés on 08/02/13.
//  Copyright (c) 2013 Lafosca. All rights reserved.
//

#import "ViewController.h"
#import "Tweet.h"
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

//    [self updateTweetsInUI];
    
//    [self fetchTweets];
}

- (void)fetchTweets
{
    NSURL *url = [NSURL URLWithString:@"http://search.twitter.com/search.json?q=iphone"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // TODO: Perform a JSON query easily
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [LFSSaveInBackgroundOperation saveInBackgroundWithBlock:^(NSManagedObjectContext *backgroundContext) {
            [Tweet importFromArray:JSON[@"results"] inContext:backgroundContext];
        } completion:^{
            [self updateTweetsInUI];
        }];
        
        [self updateTweetsInUI];
        
    } failure:nil];
    
    [operation start];
}

- (void)updateTweetsInUI
{
    NSFetchRequest *tweetsRequest = [[NSFetchRequest alloc] initWithEntityName:[Tweet entityName]];
    
    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    [tweetsRequest setSortDescriptors:@[sortByDate]];
    [tweetsRequest setFetchLimit:100];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:tweetsRequest
                                                                        managedObjectContext:[[LFSDataModel sharedModel] mainContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweet = (Tweet *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *textLabel = (UILabel *)[cell viewWithTag:1];
    [textLabel setText:tweet.text];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

@end
