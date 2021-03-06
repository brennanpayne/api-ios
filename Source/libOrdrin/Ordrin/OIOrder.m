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

#import "OIOrder.h"
#import "OICore.h"
#import "OIAddress.h"
#import "OICardInfo.h"
#import "OIUser.h"
#import "ASIFormDataRequest.h"
#import "OIRestaurantBase.h"
#import "JSONKit.h"
#import "OIUserInfo.h"
#import "OIOrderItem.h"
#import "OIUserInfo.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Variables

NSString *const OIOrderBaseURL = @"https://o-test.ordr.in";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Implementation

@interface OIOrder (Private)
+ (OIOrder *)createOrderFromDictionary:(NSDictionary *)orderDict;
@end

@implementation OIOrder {
@private
  NSString          *__orderID;
  NSNumber          *__total;
  NSNumber          *__tip;
  NSDate            *__date;
  NSArray           *__items;
  OIRestaurantBase  *__restaurantBase;
}

@synthesize orderID        = __orderID;
@synthesize total          = __total;
@synthesize tip            = __tip;
@synthesize date           = __date;
@synthesize items          = __items;
@synthesize restaurantBase = __restaurantBase;

#pragma mark -
#pragma mark Properties

- (NSString *)description {
  return [NSString stringWithFormat:@"orderId: %@\ntotal: %d\ntip: %d\ndate: %@\nitems: %@\nrestaurant: %@", __orderID, __total.intValue, __tip.intValue, __date, __items, __restaurantBase.description];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
  OI_RELEASE_SAFELY( __orderID );
  OI_RELEASE_SAFELY( __total );
  OI_RELEASE_SAFELY( __tip );
  OI_RELEASE_SAFELY( __date );
  OI_RELEASE_SAFELY( __items );
  OI_RELEASE_SAFELY( __restaurantBase );
  
  [super dealloc];
}

#pragma mark -
#pragma mark Class methods

+ (void)createOrderWithRestaurantId:(NSString *)restaurantID atAddress:(OIAddress*)address withCard:(OICardInfo *)card date:(NSDate *)date orderItems:(NSString *)orderItems tip:(NSNumber *)tip usingBlock:(void (^)(NSError *error))block {
  
  OIUserInfo *userInfo = [OIUserInfo sharedInstance];
  NSString *URL = [NSString stringWithFormat:@"%@/o/%d", OIOrderBaseURL, restaurantID];
  __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL]];
  [request setRequestMethod:@"POST"];
  
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components = [calendar components:NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
  OI_RELEASE_SAFELY( calendar );

  NSString *deliveryDate = [NSString stringWithFormat:@"%d-%d",components.month, components.day];
  NSString *deliveryTime = [NSString stringWithFormat:@"%d:%d",components.hour, components.minute];  
  NSString *cardExpiry = [NSString stringWithFormat:@"%@/%@",card.expirationMonth, card.expirationYear];  
  [request setPostValue:orderItems forKey:@"tray"];
  [request setPostValue:tip forKey:@"tip"];
  [request setPostValue:deliveryDate forKey:@"delivery_date"];
  [request setPostValue:deliveryTime forKey:@"delivery_time"];
  [request setPostValue:OI_EMPTY_STR_IF_NIL(userInfo.firstName) forKey:@"first_name"];
  [request setPostValue:OI_EMPTY_STR_IF_NIL(userInfo.lastName) forKey:@"last_name"];
  [request setPostValue:OI_EMPTY_STR_IF_NIL(address.address1) forKey:@"addr"];
  [request setPostValue:OI_EMPTY_STR_IF_NIL(address.city) forKey:@"city"];
  [request setPostValue:OI_EMPTY_STR_IF_NIL(address.state) forKey:@"state"];
  [request setPostValue:OI_EMPTY_STR_IF_NIL(address.phoneNumber) forKey:@"phone"];  
  [request setPostValue:OI_ZERO_IF_NIL(address.postalCode) forKey:@"zip"];
  [request setPostValue:userInfo.email forKey:@"em"];
  [request setPostValue:userInfo.password.sha256 forKey:@"password"];
  [request setPostValue:OI_EMPTY_STR_IF_NIL(@"mastercard") forKey:@"card_name"];
  [request setPostValue:OI_EMPTY_STR_IF_NIL(card.number) forKey:@"card_number"];
  [request setPostValue:OI_ZERO_IF_NIL(card.cvc) forKey:@"card_cvc"];
  [request setPostValue:OI_EMPTY_STR_IF_NIL(cardExpiry) forKey:@"card_expiry"];
  [request setPostValue:OI_EMPTY_STR_IF_NIL(card.address.address1) forKey:@"card_bill_addr"];
  [request setPostValue:OI_EMPTY_STR_IF_NIL(card.address.address2) forKey:@"card_bill_addr2"];
  [request setPostValue:OI_EMPTY_STR_IF_NIL(card.address.city) forKey:@"card_bill_city"];
  [request setPostValue:OI_EMPTY_STR_IF_NIL(card.address.state) forKey:@"card_bill_state"];
  [request setPostValue:OI_ZERO_IF_NIL(card.address.postalCode) forKey:@"card_bill_zip"];  
    
  [request setCompletionBlock:^{
    NSDictionary *json = [[request responseString] objectFromJSONString];
    if ( json ) {
      NSNumber *errorCode = [json objectForKey:@"_error"];
      if ( errorCode.integerValue == 0 ) {
        if ( block ) {
          block( nil );
        }
      } else {
        NSString *msg = [json objectForKey:@"text"];
        NSError *error = [NSError errorWithDomain:msg code:0 userInfo:nil];
        if ( block ) {
          block( error );
        }
      }
    }
  }];
  
  OIAPIClient *client = [OIAPIClient sharedInstance];
  [client appendRequest:request authorized:YES];  
}

+ (void)loadOrderHistoryUsingBlock:(void (^)(NSMutableArray *orders))block {
  OIUserInfo *userInfo = [OIUserInfo sharedInstance];
  NSString *URLParams = [NSString stringWithFormat:@"/u/%@/orders",userInfo.email.urlEncode];
  NSString *URL = [NSString stringWithFormat:@"%@%@", OIUserBaseURL, URLParams];
    
  __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL]];
  
  [request setCompletionBlock:^{        
    NSDictionary *json = [[request responseString] objectFromJSONString];
    NSArray *allKeys = [json allKeys];    
    NSString *item;
    
    NSMutableArray *newOrders = [NSMutableArray array];
    
    for (item in allKeys) {      
      NSDictionary *orderDict = [json objectForKey:item];      
      if( orderDict ) {
        OIOrder *order = [OIOrder createOrderFromDictionary:orderDict];
        [newOrders addObject:order];
      }
    }    
    if ( block ) {
      block( newOrders );
    }    
  }];
  
  [request setFailedBlock:^{
    block( [NSMutableArray array] );
  }];
  
  OIAPIClient *client = [OIAPIClient sharedInstance];
  [client appendRequest:request authorized:YES userAuthenticator:[userInfo createAuthenticatorWithUri:URLParams]]; 
}

+ (void)loadOrderByID:(NSString *)ID usingBlock:(void (^)(OIOrder *order))block {
  OIUserInfo *userInfo = [OIUserInfo sharedInstance];  
  NSString *URLParams = [NSString stringWithFormat:@"/u/%@/order/%@", userInfo.email.urlEncode, ID.urlEncode];
  
  NSString *URL = [NSString stringWithFormat:@"%@%@", OIUserBaseURL, URLParams];  
  __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL]];
  
  [request setCompletionBlock:^{    
    NSDictionary *json = [[request responseString] objectFromJSONString];    
    if( json ) {
      OIOrder *order = [OIOrder createOrderFromDictionary:json];      
      if ( block ) {
        block( order );
      }
    }
    else {
      block( nil );      
    }
  }];
  
  [request setFailedBlock:^{
    block( nil );
  }];
  
  OIAPIClient *client = [OIAPIClient sharedInstance];
  [client appendRequest:request authorized:YES userAuthenticator:[userInfo createAuthenticatorWithUri:URLParams]]; 
}

@end

#pragma mark -
#pragma mark Private methods

@implementation OIOrder (Private)

+ (OIOrder *)createOrderFromDictionary:(NSDictionary *)orderDict {
  OIOrder *order = [[[OIOrder alloc] init] autorelease];
  OIRestaurantBase *restaurantBase = [[OIRestaurantBase alloc] init];        
  
  order.orderID = [orderDict objectForKey:@"oid"];
  order.total = [orderDict objectForKey:@"total"];
  order.tip = [orderDict objectForKey:@"tip"];
  order.date = [orderDict objectForKey:@"ctime"];
  
  restaurantBase.ID = [orderDict objectForKey:@"rid"];
  restaurantBase.name = [orderDict objectForKey:@"rname"];
  
  order.restaurantBase = restaurantBase;
  OI_RELEASE_SAFELY( restaurantBase );  
  
  NSDictionary *itemsDict = [orderDict objectForKey:@"item"];        
  NSArray *allKeys = itemsDict.allKeys;
  
  for ( NSString *key in allKeys ) {
    NSDictionary *itemDict = [itemsDict objectForKey:key];
    
    OIOrderItem *orderItem = [[OIOrderItem alloc] init];
    orderItem.ID = [itemDict objectForKey:@"id"];
    orderItem.name = [itemDict objectForKey:@"name"];
    orderItem.price = [itemDict objectForKey:@"price"];
    orderItem.quantity = [itemDict objectForKey:@"qty"];
    
    NSArray *optsHashes = [itemDict objectForKey:@"opts"];
    NSMutableArray *opts = [NSMutableArray array];
    
    for ( NSDictionary *optDict in optsHashes ) {
      OIOrderItem *optItem = [[OIOrderItem alloc] init];
      optItem.ID = [optDict objectForKey:@"id"];
      optItem.name = [optDict objectForKey:@"name"];
      optItem.price = [optDict objectForKey:@"price"];
      optItem.quantity = [optDict objectForKey:@"qty"];
    
      [opts addObject:optItem];
      OI_RELEASE_SAFELY( optItem );
    }
    
    orderItem.opts = opts;
    OI_RELEASE_SAFELY( orderItem );
  }    

  return order;
}

@end


