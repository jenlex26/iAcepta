//
//  ApiDelegate.h
//  EvoPaymentAPI
//
//  Created by Roberto on 02/02/18.
//  Copyright © 2018 NA-AT Technologies. All rights reserved.
//

#import "EvoUtils.h"

@protocol EvoApiDelegate

/**
 Event to notify connection status changed
 */
@required
- (void)evoApiConnectionStateChanged:(BOOL)success
                               error:(NSString*)error
                                code:(NSString*)code;

/**
 Event to notify result of initEncryption
 */
@required
- (void)evoApiEncryptionInitialized:(BOOL)success
                              error:(NSString*)error
                               code:(NSString*)code
                            tokenEW:(NSData*)tokenEW
                            tokenES:(NSData*)tokenES;

/**
 Event to notify result of endEncryption
 */
@required
- (void)evoApiEncryptionEnded:(BOOL)success
                        error:(NSString*)error
                         code:(NSString*)code;

/**
 Event to notify result of setBinTable
 */
@required
- (void)evoApiBinTableConfigured:(BOOL)success
                           error:(NSString*)error
                            code:(NSString*)code;

/**
 Event to notify result of getBinTable
 */
@required
- (void)evoApiBinTableReceived:(BOOL)success
                         error:(NSString*)error
                          code:(NSString*)code
                    binTableId:(NSString*)binTableId
               binTableVersion:(NSString*)binTableVersion
                     binStartN:(NSString*)binStartN
                       binEndN:(NSString*)binEndN;

/**
 Event to notify result of getAppVersion
 */
@required
- (void)evoApiAppVersionReceived:(BOOL)success
                           error:(NSString*)error
                            code:(NSString*)code
                         tokenES:(NSData*)tokenES
                         tokenQ8:(NSData*)tokenQ8;

/**
 Event to notify result of getCardBin
 */
@required
- (void)evoApiCardBinReceived:(BOOL)success
                        error:(NSString*)error
                         code:(NSString*)code
                          pan:(NSString*)pan;

/**
 Event to notify result of startTransaction
 */
@required
- (void)evoApiTransactionStarted:(BOOL)success
                           error:(NSString*)error
                            code:(NSString*)code
                         tokenB2:(NSData*)tokenB2
                         tokenB3:(NSData*)tokenB3
                         tokenB4:(NSData*)tokenB4
                         tokenQ8:(NSData*)tokenQ8
                         tokenQ9:(NSData*)tokenQ9
                         tokenEY:(NSData*)tokenEY
                         tokenEZ:(NSData*)tokenEZ
                         tokenES:(NSData*)tokenES
                         tokenC0:(NSData*)tokenC0
                         tokenQE:(NSData*)tokenQE
                         tokenCZ:(NSData*)tokenCZ;

/**
 Event to notify result of endTransaction
 */
@required
- (void)evoApiTransactionEnded:(BOOL)success
                         error:(NSString*)error
                          code:(NSString*)code
                cryptogramType:(enum CryptogramType)cryptogramType
                    cryptogram:(NSString*)cryptogram
                  authResponse:(NSString*)authResponse
               scriptsProcesed:(NSInteger)scriptsProcesed
                 scriptsResult:(NSArray*)scriptsResult;

@required
- (void)evoApiBatteryValueResult:(BOOL)success
                     error:(NSString*)error
                      code:(NSString*)code
               bateryValue:(NSInteger)bateryValue;

@required
- (void)evoApiTransactionCanceled:(BOOL)success
                   error:(NSString*)error
                    code:(NSString*)code;

@end
