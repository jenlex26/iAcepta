//
//  SimpleResponse.h
//  EvoPaymentAPI
//
//  Created by Roberto on 03/02/18.
//  Copyright © 2018 NA-AT Technologies. All rights reserved.
//

@interface SimpleResponse: NSObject

@property BOOL success;

@property NSString *error;

@property NSString *code;

@end

@implementation SimpleResponse

@synthesize success;
@synthesize error;
@synthesize code;

- (id) init:(BOOL)success
              error:(NSString*)error
               code:(NSString*)code {
    self = [super init];
    if (self) {
        self.success = success;
        self.error = error;
        self.code = code;
    }
    return self;
}

@end
