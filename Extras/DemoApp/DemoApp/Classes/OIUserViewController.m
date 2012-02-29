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

#import "OIUserViewController.h"
#import "OIUserLogInView.h"
#import "OINewUserView.h"
#import "OIApplicationData.h"
#import "OIAccountNavigatorView.h"

@implementation OIUserViewController {
@private
  UIButton        *__buttonLogIn;
  UIButton        *__buttonNewAccount;
  OIUserLogInView *__logInView;
  OINewUserView   *__newUserView;
}

- (void)showViews:(BOOL) userLogged {
  if ( !userLogged ) {
    self.title = NSLocalizedString( @"User: Not Logged In", "" );
    [self hideButtons:NO];
  }
  else {
    OIApplicationData *appDataManager = [OIApplicationData sharedInstance];
    self.title = [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString( @"User:", "" ), [[appDataManager currentUser] firstName], [[appDataManager currentUser] lastName]];
    [self hideButtons:YES];

    CGRect viewRect = CGRectMake(0, 0, 320, 480);
    OIAccountNavigatorView *__accountNavigatorView = [[OIAccountNavigatorView alloc] initWithFrame:viewRect];
    [self.view addSubview:__accountNavigatorView];
    [__accountNavigatorView release];
  }
}

#pragma mark -
#pragma mark Lifecycle

- (void)loadView {
  [super loadView];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  __buttonLogIn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  __buttonLogIn.frame = CGRectMake(35, 30, 250, 30);
  [__buttonLogIn setTitle:@"Log In to the Existing Account" forState:UIControlStateNormal];
  [self.view addSubview:__buttonLogIn]; 
  
  __buttonNewAccount = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  __buttonNewAccount.frame = CGRectMake(35, 80, 250, 30);
  [__buttonNewAccount setTitle:@"Create New Account" forState:UIControlStateNormal];
  [self.view addSubview:__buttonNewAccount]; 
  
  [__buttonLogIn addTarget:self action:@selector(buttonLogInPressed) forControlEvents:UIControlEventTouchUpInside]; 
  [__buttonNewAccount addTarget:self action:@selector(buttonNewAccountPressed) forControlEvents:UIControlEventTouchUpInside];  
  
  OIApplicationData *appDataManager = [OIApplicationData sharedInstance];
  [self showViews:[appDataManager isUserLogged]];
}

- (void)refresh {
  OIApplicationData *appDataManager = [OIApplicationData sharedInstance];
  [self showViews:[appDataManager isUserLogged]];
}

- (void)hideButtons:(BOOL) hide {
  __buttonLogIn.hidden = hide;
  __buttonNewAccount.hidden = hide;
}

- (void)buttonLogInPressed {
  if ( __newUserView ) {
    [__newUserView removeFromSuperview];    
    OI_RELEASE_SAFELY( __newUserView );        
  }

  if ( !__logInView ) {
    CGRect viewRect = CGRectMake(0, 200, 480, 200);
    __logInView = [[OIUserLogInView alloc] initWithFrame:viewRect];
    [self.view addSubview:__logInView];
  }
}

- (void)buttonNewAccountPressed {
  if ( __logInView ) {
    [__logInView removeFromSuperview];
    OI_RELEASE_SAFELY( __logInView );    
  }
    
  if ( !__newUserView ) {
    CGRect viewRect = CGRectMake(0, 160, 480, 200);
    __newUserView = [[OINewUserView alloc] initWithFrame:viewRect];
    [self.view addSubview:__newUserView];
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
  OI_RELEASE_SAFELY( __logInView );
  OI_RELEASE_SAFELY( __newUserView );
  
  [super dealloc];
}
@end
