/*
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

/**
 * Class contain basic informations about user.
 */
#import <Foundation/Foundation.h>

extern NSString const* OIUserBaseURL;

@class OIAddress;
@class OICardInfo;
@class OIOrder;

@interface OIUser : NSObject

/// First name.
@property (nonatomic, readwrite, copy) NSString *firstName;
/// Last name.
@property (nonatomic, readwrite, copy) NSString *lastName;
/// Array of user addresses.
@property (nonatomic, readwrite, retain) NSMutableArray *addresses;
/// Array of user credit cards.
@property (nonatomic, readwrite, retain) NSMutableArray *creditCards;
/// Array of user orders.
@property (nonatomic, readwrite, retain) NSMutableArray *orders;

#pragma mark -
#pragma mark Class methods

/**
 * Load account information by user email and password.
 *
 * @param email User email.
 *
 * @param password User password.
 *
 * @return block Return (OIUser) instance if request finished correctly.
 *
 * @return blockError Return (NSError) instance.
 */
+ (void)accountInfo:(NSString *)email password:(NSString *)password usingBlockUser:(void (^)(OIUser *user))blockUser usingBlockError:(void (^)(NSError *error))blockError;

/**
 * Create new account for OIUser instance. Call block with nil parameter if succeeded or with a 
 * request error if failed
 *
 * @param Information about new account (OIUser).
 *
 * @param email User email.
 *
 * @param password User password.
 *
 * @return block Return nil if request finished correctly.
 */
+ (void)createNewAccount:(OIUser *)account email:(NSString *)email password:(NSString *)password usingBlock:(void (^)(NSError *error))block;

/**
 * Create new OIUser instance by email, first name and last name.
 *
 * @param firstName First name of user.
 *
 * @param lastName Last name of user.
 */
+ (OIUser *)userWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;

/**
 * Update user password.
 * 
 * @param password New password.
 *
 * @param block Block return nil if request finished successfully else error (NSError).
 */
+ (void)updatePassword:(NSString *)password usingBlock:(void (^)(NSError *error))block;

@end

#pragma mark -
#pragma mark Address

@interface OIUser (Address)

/**
 * Load all user addresses into the OIUser instance. Call block with nil 
 * parameter.
 */
- (void)initAllAddresses;

/**
 * Add address (OIAddress) to the server and to the addresses of the user (OIUser).
 * 
 * @param address New address (OIAddress) which will be added to the user addresses (server, application).
 * 
 */
- (void)addAddress:(OIAddress *)address;

/**
 * Change user address (overwrite). 
 * 
 * @param index Index of the address (OIAddress) in user addresses, which will be updated.
 *
 * @param newAddress Changed address (OIAddress), which will replace previous address.
 */
- (void)updateAddressAtIndex:(NSUInteger)index withAddress:(OIAddress *)newAddress;

/**
 * Delete user address by its nickname.
 *
 * @param nickname Addresses nickname, which will be deleted.
 */
- (void)deleteAddressByNickname:(NSString *)nickname;
@end

#pragma mark -
#pragma mark CreditCard

@interface OIUser (CreditCard)

/**
 * Load all user credit cards into the OIUser instance. 
 */
- (void)initAllCreditCards;

/**
 * Add credit card (OICardInfo) to the server and to the credit cards of the
 * user (OIUser).
 * 
 * @param address New credit card (OICardInfo), which will be added to the user credit cards (server, application).
 */
- (void)addCreditCard:(OICardInfo *)creditCard;

/**
 * Change user credit card (overwrite). 
 * 
 * @param index Index of the credit card (OICardInfo) in user credit cards, which will be updated.
 *
 * @param newCreditCard (OICardInfo)
 * Changed credit card, which will replace previous credit card.
 */
- (void)updateCreditCardAtIndex:(NSUInteger)index withCreditCard:(OICardInfo *)newCreditCard;

/**
 * Delete user credit card by its nickname.
 *
 * @param nickname Credit cards nickname, which will be deleted.
 */
- (void)deleteCreditCardByNickname:(NSString *)nickname;
@end

#pragma mark -
#pragma mark Order

@interface OIUser (Order)

/**
 * Load all user orders into the OIUser instance.
 */
- (void)initOrderHistory;
@end

