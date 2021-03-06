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
 *      Daniel Krezelok (daniel.krezelok@tapmates.com)
 */

#import "OrderAddressesViewController.h"
#import "OICore.h"
#import "OrderTableView.h"
#import "OrderAddressesDataSource.h"

@interface OrderAddressesViewController (Private)
- (void)createModel;
@end

@implementation OrderAddressesViewController

@synthesize delegate = __delegate;

#pragma mark -
#pragma mark Initializations

- (id)initWithAddresses:(NSArray *)addresses {
  self = [super init];
  if ( self ) {
    __addresses = [addresses retain];
  }
  
  return self;
}

#pragma mark -
#pragma mark Lifecycles

- (void)loadView {
  [super loadView];
  
  __addressesView = [[OrderTableView alloc] init];
  self.view = __addressesView;
  
  [self createModel];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  
  [self releaseWithDealloc:NO];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [__delegate addressDidSelect:indexPath.row];
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)releaseWithDealloc:(BOOL)dealloc {
  OI_RELEASE_SAFELY( __addressesView );
  if ( dealloc ) {
    __delegate = nil;
    OI_RELEASE_SAFELY( __addresses );
    OI_RELEASE_SAFELY( __dataSource );    
  }
}

- (void)dealloc {
  [self releaseWithDealloc:YES];
  [super dealloc];
}

@end

#pragma mark -
#pragma mark Private

@implementation OrderAddressesViewController (Private)

- (void)createModel {
  __dataSource = [[OrderAddressesDataSource alloc] initWithAddresses:__addresses];
  __addressesView.tableView.dataSource = __dataSource;
  __addressesView.tableView.delegate = self;
}

@end
