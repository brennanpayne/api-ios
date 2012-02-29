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

#import <Foundation/Foundation.h>

@interface OIAddress : NSObject

/// The nickname of this address (i.e. Home, Work).
@property (nonatomic, readwrite, copy) NSString *nickname;
/// The street address.
@property (nonatomic, readwrite, copy) NSString *address1;
/// The 2nd line of the address (optional).
@property (nonatomic, readwrite, copy) NSString *address2;
/// The city.
@property (nonatomic, readwrite, copy) NSString *city;
/// The state.
@property (nonatomic, readwrite, copy) NSString *state;
/// The zip code.
@property (nonatomic, readwrite, retain) NSNumber *postalCode;
/// The phone number.
@property (nonatomic, readwrite, copy) NSString *phoneNumber;
/// User id is set only if address owner is user not restaurant.
@property (nonatomic, readwrite, copy) NSString *userId;

#pragma mark -
#pragma mark Instance methods

- (void)updateWithAddress:(OIAddress *)address;

- (void)deleteAddress;

#pragma mark -
#pragma mark Class methods

/**
 * Created simple address (OIAddress).
 *
 * @param street
 * The street name.
 *
 * @param city
 * The city.
 *
 * @param postalCode
 * The zip code.
 *
 * @return 
 * Return instance of OIAddress.
 */
+ (OIAddress *)addressWithStreet:(NSString *)street city:(NSString *)city postalCode:(NSNumber *)postalCode;

@end