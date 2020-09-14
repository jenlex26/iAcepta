//
//  UtilitiesVerifone.m
//  iAcepta
//
//  Created by QUALITY on 7/31/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UtilitiesVerifone.h"

@implementation UtilitiesVerifone

- (void) someBody {
    NSLog(@"SomeMethod Ran");
}

- (NSString *)stringFromHexString:(NSString *)hexString {
    if (([hexString length] % 2) != 0)
        return nil;
    NSMutableString *string = [NSMutableString string];
    for (NSInteger i = 0; i < [hexString length]; i += 2) {
        NSString *hex = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSInteger decimalValue = 0;
        sscanf([hex UTF8String], "%x", &decimalValue);
        [string appendFormat:@"%c", decimalValue];
    }
    hexString=string;
    return string;
}

@end
