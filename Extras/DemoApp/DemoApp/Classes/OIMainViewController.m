/**
 * Copyright (c) 2012, Tapmates s.r.o. (www.tapmates.com).
 *
 * All rights reserved. This source code can be used only for purposes specified 
 * by the given license contract signed by the rightful deputy of Tapmates s.r.o. 
 * This source code can be used only by the owner of the license.
 * 
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
 *
 *  @author(s):
 *      Petr Reichl (petr@tapmates.com)
 */
#import "OIMainViewController.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Interface

@interface OIMainViewController()< UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, readwrite, retain) NSArray *dataSet;

-(void)releaseWithDealloc:(BOOL)dealloc;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Implementation

@implementation OIMainViewController {
@private
  UITableView *__tableView;
  NSArray *__dataSet;
}

@synthesize dataSet = __dataSet;

#pragma mark -
#pragma mark Lifecycle

- (void)loadView {
  [super loadView];

  self.view.backgroundColor = [UIColor whiteColor];

  __tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  __tableView.delegate = self;
  __tableView.dataSource = self;
  [self.view addSubview:__tableView];

  // List of restaurants

  OIRestaurantAddress *address = [OIRestaurantAddress restaurantAddressWithStreet:@"1 Main St"
                                                                             city:@"College Station"
                                                                       postalCode:[NSNumber numberWithInt:77840]];

  // You can use [OIDateTime dateTime:[NSDate date] or [OIDateTime dateTimeASAP]

  [OIRestaurant restaurantsNearAddress:address availableAt:[OIDateTime dateTime:[NSDate date]] usingBlock:^void(NSArray *restaurants) {
    self.dataSet = restaurants;
    [__tableView reloadData];
  }];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [__dataSet count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
  if ( ! cell ) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  cell.textLabel.text = [(OIRestaurant *)[__dataSet objectAtIndex:indexPath.row] name];

  return cell;
}

#pragma mark -
#pragma mark Memory Management

-(void)releaseWithDealloc:(BOOL)dealloc {
  [__tableView release], __tableView = nil;
  
  if ( dealloc ) {
    [__dataSet release], __dataSet = nil;
  }
}

- (void)viewDidUnload {
  [self releaseWithDealloc:NO];
  [super viewDidUnload];
}

- (void)dealloc {
  [self releaseWithDealloc:YES];
  [super dealloc];
}

@end