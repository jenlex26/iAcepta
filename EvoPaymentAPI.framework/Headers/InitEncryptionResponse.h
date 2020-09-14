//
//  InitEncryptionResponse.h
//  EvoPaymentAPI
//
//  Created by Roberto on 03/02/18.
//  Copyright © 2018 NA-AT Technologies. All rights reserved.
//

#import "SimpleResponse.h"

@interface InitEncryptionResponse: SimpleResponse

@property NSData *tokenEW;

@property NSData *tokenES;

@end

@implementation InitEncryptionResponse

@synthesize tokenEW;

@synthesize tokenES;

- (id) initWithSuccess:(BOOL)success
              andError:(NSString*)error
               andCode:(NSString*)code
            andTokenEW:(NSData*)tokenEW
            andTokenES:(NSData*)tokenES {
    self = [super initWithSuccess: success andError: error andCode: code];
    if (self) {
        self.tokenEW = tokenEW;
        self.tokenES = tokenES;
    }
    return self;
}

@end
