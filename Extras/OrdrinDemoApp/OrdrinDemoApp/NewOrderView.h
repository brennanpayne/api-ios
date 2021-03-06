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

#import <UIKit/UIKit.h>

@interface NewOrderView : UIView {

@private
  UIScrollView *__scrollView;
  UITableView *__tableView;
  UIDatePicker *__datePicker;
  
  UIButton *__restaurantsButton;
  UIButton *__addressesButton;
  UIButton *__creditCardButton;
  
  UITextField *__cardNumberField;
  UITextField *__securityCodeField;
  UITextField *__tipField;  
}

@property (nonatomic, readonly) UITextField *tipField;
@property (nonatomic, readonly) UITextField *cardNumberField;
@property (nonatomic, readonly) UITextField *securityCodeField;

@property (nonatomic, readonly) UIDatePicker *datePicker;
@property (nonatomic, readonly) UITableView *tableView;

@property (nonatomic, readonly) UIButton *creditCardButton;
@property (nonatomic, readonly) UIButton *restaurantsButton;
@property (nonatomic, readonly) UIButton *addressesButton;

@end
