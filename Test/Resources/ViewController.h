//
//  ViewController.h
//  LFCoreData
//
//  Created by David Cortés on 08/02/13.
//  Copyright (c) 2013 Lafosca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
