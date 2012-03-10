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

#import "AddAddressViewController.h"
#import "OICore.h"
#import "AddAddressView.h"
#import "OIAddress.h"

@interface AddAddressViewController (Private)
- (void)hideKeyboard;
- (void)createAddressButtonDidPress;
@end

@implementation AddAddressViewController

#pragma mark -
#pragma mark Initializations

- (id)init {
  self = [super init];
  if ( self ) {
    self.title = @"Add address";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(createAddressButtonDidPress)];
  }
  
  return self;
}

#pragma mark -
#pragma mark Lifecycle

- (void)loadView {
  [super loadView];

  __addAddressView = [[AddAddressView alloc] init];  
  self.view = __addAddressView;
}

- (void)viewDidUnload {
  [super viewDidUnload];
  
  [self releaseWithDealloc:NO];
}

#pragma mark -
#pragma mark Events

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [self hideKeyboard];
}

#pragma mark -
#pragma mark Memory management

- (void)releaseWithDealloc:(BOOL)dealloc {
  OI_RELEASE_SAFELY( __addAddressView );
  if ( dealloc ) {
  }  
}

- (void)dealloc {
  [self releaseWithDealloc:YES];
  [super dealloc];
}

@end

#pragma mark -
#pragma mark Private

@implementation AddAddressViewController (Private)

- (void)hideKeyboard {
  [__addAddressView.stateField resignFirstResponder];
  [__addAddressView.zipField resignFirstResponder];
  [__addAddressView.cityField resignFirstResponder];
  [__addAddressView.addr1Field resignFirstResponder];
  [__addAddressView.addr2Field resignFirstResponder];
  [__addAddressView.phoneField resignFirstResponder];  
}

- (void)createAddressButtonDidPress {
  NSString *street = __addAddressView.addr1Field.text;
  NSString *city = __addAddressView.cityField.text;
  NSNumber *postalCode = [NSNumber numberWithInt: __addAddressView.zipField.text.intValue];    
  OIAddress *address = [OIAddress addressWithStreet:street city:city postalCode:postalCode];
  
  address.nickname = __addAddressView.nickNameField.text;
  address.state = __addAddressView.stateField.text;
  address.address2 = __addAddressView.addr2Field.text;
  address.phoneNumber = __addAddressView.phoneField.text;
  
  [OIAddress addAddress:address usingBlock:^void( NSError *error ) {
    if ( error ) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [alert show];
      OI_RELEASE_SAFELY( alert );
    }
  }];
}

@end