//
//  Api.h
//  EvoPaymentAPI
//
//  Created by Roberto on 01/02/18.
//  Copyright © 2018 NA-AT Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvoApiDelegate.h"
#import "SimpleResponse.h"

@interface EvoApi: NSObject

// Delegate to be used for responses
@property (nonatomic, retain) id <EvoApiDelegate> delegate;

/**
 Api singleton instance

 @return Id
 */
+ (EvoApi*) main;


/**
 Prepares Api, stablishing delegate to be used for responses

 @param delegate delegate to be used
 */
- (void) initialize:(id)delegate;


/**
 Connects to device
 */
- (void) connect;

/**
 Indicates if a connection to a device is active

 @return Object with boolean indicating if there is a connection, an error and a error code
 */
- (SimpleResponse*)isConnected;


/**
 Send a EOT command
 */
- (void)terminateTransmission;


/**
 Initializes encryption on connected device
 */
- (void)initEncryption;


/**
 Ends encryption on connected device

 @param tokenEX Token used to end encryption
 */
- (void)endEncryptionWithToken:(NSData*)tokenEX;


/**
 Load the exception bin table on connected device

 @param tokenET Token with data of bin table
 */
- (void)setBinTableWithToken:(NSData*)tokenET;


/**
 Get the loaded bin table loaded on connected device
 */
- (void)getBinTable;


/**
 Get current app version loaded on connected device
 */
- (void)getAppVersion;


/**
 Get a card bin from connected device

 @param timeout Time to wait to cancel transaction
 */
- (void)getCardBinWithTimeout:(uint)timeout;


/**
 Starts a transaction on connected device

 @param timeout Time to wait to cancel transaction
 @param date Current date
 @param transaction Transaction type enumeration value
 @param amount Amount of transaction
 @param cashback Amount of cash back
 @param currency Currency code
 @param decision Decision of device enumeration value
 @param flagCCV Indicates if CCV security code should be provided
 @param flagExpDate Indicates if expiration date of card should be provided
 */
- (void)startTransactionWithTimeout:(uint)timeout
                            andDate:(NSDate*)date
                 andTransactionType:(enum TransactionType)transaction
                          andAmount:(double)amount
                  andCashBackAmount:(double)cashback
                    andCurrencyCode:(NSString*)currency
                andTerminalDecision:(enum TerminalDecision)decision
                         andflagCCV:(BOOL)flagCCV
              andFlagExpirationDate:(BOOL)flagExpDate;


/**
 End transaction with specified response and data

 @param response Response enumeration value
 @param tokenB5 Received B5 token
 @param tokenB6 Received B6 token
 */
- (void)endTransactionWithResponse:(enum TransactionResponse)response
                        andTokenB5:(NSData*)tokenB5
                        andTokenB6:(NSData*)tokenB6;

/**
 Cancel current transaction waiting in PinPad
 */
-(void)cancelTransaction;

/**
 Get PinPad available battery value
 */
-(void)getBatteryValue;

@end
