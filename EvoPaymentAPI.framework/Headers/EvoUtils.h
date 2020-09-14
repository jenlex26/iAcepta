//
//  LibApi
//  EvoPaymentAPI
//
//  Created by Roberto on 03/02/18.
//  Copyright © 2018 NA-AT Technologies. All rights reserved.
//

#ifndef EvoPaymentUtils

#define EvoPaymentUtils

#define VX600_APP_ID 50
#define API_DEST_ID 128

const int COMMAND_TIMEOUT = 30;

#define API_SUCCESS @"00"
#define API_COMMAND_TIMEDOUT @"06"
#define API_UNEXPECTED_RESPONSE @"98"
#define API_DEVICE_DISCONNECTED @"202"
#define API_TIMEOUT_VALUE_INVALID @"203"
#define API_DATE_INVALID @"204"
#define API_TRANSACTION_INVALID @"205"
#define API_TRANSACTION_AMOUNT_INVALID @"206"
#define API_CASHBACK_AMOUNT_INVALID @"207"
#define API_CURRENCY_INVALID @"208"
#define API_TERMINAL_DECISION_INVALID @"209"
#define API_TERMINAL_OCCUPIED @"210"
#define API_RETRY_COUNT_REACHED @"211"

#define SYSTEM_ERROR_MESSAGE @"Error de sistema"
#define VMF_API_ERROR_MESSAGE @"Error de VMF"

static inline NSString* NSStringFromBOOL(BOOL aBool) {
    return aBool ? @"TRUE" : @"FALSE";
}

NSString * const COMMAND_INIT_ENCRYPTION = @"CA1";
NSString * const COMMAND_END_ENCRYPTION = @"CA2";
NSString * const COMMAND_SET_BIN_TABLE = @"CA5";
NSString * const COMMAND_GET_BIN_TABLE = @"CA6";
NSString * const COMMAND_GET_APP_VERSION = @"CA8";
NSString * const COMMAND_GET_CARD_BIN = @"CC0";
NSString * const COMMAND_START_TRANSACTION = @"CC1";
NSString * const COMMAND_END_TRANSACTION = @"CC4";
NSString * const COMMAND_BATTERY_STATUS = @"CBV";
NSString * const COMMAND_CANCEL_TRANSACTION = @"C72";

NSString * const MORE_PACKETS_RESPONSE_CODE = @"03";
NSString * const INVALID_FORMAT_RESPONSE_CODE = @"55";

NSString * const CURRENCY_CODE_MXN = @"0484";
NSString * const CURRENCY_CODE_USD = @"0840";

NSString * const TOKEN_ES = @"ES";
NSString * const TOKEN_EW = @"EW";
NSString * const TOKEN_EX = @"EX";
NSString * const TOKEN_ET = @"ET";
NSString * const TOKEN_B2 = @"B2";
NSString * const TOKEN_B3 = @"B3";
NSString * const TOKEN_B4 = @"B4";
NSString * const TOKEN_Q8 = @"Q8";
NSString * const TOKEN_Q9 = @"Q9";
NSString * const TOKEN_EY = @"EY";
NSString * const TOKEN_EZ = @"EZ";
NSString * const TOKEN_C0 = @"C0";
NSString * const TOKEN_QE = @"QE";
NSString * const TOKEN_B5 = @"B5";
NSString * const TOKEN_B6 = @"B6";
NSString * const TOKEN_CZ = @"CZ";

NSInteger const TOKEN_ES_LENGTH = 60;
NSInteger const TOKEN_EW_LENGTH = 538;
NSInteger const TOKEN_EX_LENGTH = 68;
NSInteger const TOKEN_ET_LENGTH = 366;
NSInteger const TOKEN_B2_LENGTH = 158;
NSInteger const TOKEN_B3_LENGTH = 80;
NSInteger const TOKEN_B4_LENGTH = 20;
NSInteger const TOKEN_Q8_LENGTH = 26;
NSInteger const TOKEN_Q9_LENGTH = 238;
NSInteger const TOKEN_Q9_PIN_LENGTH = 298;
NSInteger const TOKEN_EY_LENGTH = 172;
NSInteger const TOKEN_EZ_LENGTH = 98;
NSInteger const TOKEN_C0_LENGTH = 26;
NSInteger const TOKEN_QE_LENGTH = 40;
NSInteger const TOKEN_B5_LENGTH = 38;
NSInteger const TOKEN_B6_LENGTH = 260;
NSInteger const TOKEN_CZ_LENGTH = 40;

const char STX = 0x02;
const char EOT = 0x04;
const char ETX = 0x03;
const char ENQ = 0x05;
const char ACK = 0x06;
const char NAK = 0x15;
const char SPEC = 0x0C;

const char EYE_CATCHER = '!';
const char SEPARATOR = ' ';

enum Command {
    None,
    InitEncryption,
    EndEncryption,
    SetBinTable,
    GetBinTable,
    GetAppVersion,
    GetCardBin,
    StartTransaction,
    EndTransaction,
    CancelTransaction,
    BatteryStatus
};

enum TransactionType {
    Purchase = 0,
    CashAdvance = 1,
    CorrespondentRetreat = 2,
    PurchaseWithPIN = 3,
    QPS = 4,
    PurchaseWithCashBack = 9,
    Refund = 20,
    PaymentDeposit = 21,
    Authorization = 90
};

enum TerminalDecision {
    NoDecision = 0,
    ForcedOnline = 1,
    ForcedOffline = 2,
    ForcedDecline = 3
};

enum TransactionResponse{
    Authorized = 0,
    Declined = 1,
    CommunicationsError = 2
};

enum CryptogramType {
    AAC = 0,
    TC = 1,
    ARQC = 10,
    AAR = 11
};

@interface EvoUtils: NSObject

/**
 Converts hexadecimal string to a MutableData
 
 @param hexString Hexadecimal string
 @return Mutable data
 */
+ (NSMutableData*)dataWithHexString:(NSString*)hexString;

/**
 Converts data to hexadecimal string
 
 @param data data to convert
 @return Hexadecimal string
 */
+ (NSString*)hexStringWithData:(NSData*)data;

/**
 Calculates the Longitudinal Redundancy Check (LCR) for specified data
 
 @param data Data to calculate LCR
 @return LCR
 */
+ (char)calculateLcrForData:(NSData*)data;

/**
 Loads error codes file
 */
+ (void) loadErrorCodes;

/**
 Get error text for specified code
 
 @param code Code of error
 @return Text description of error
 */
+ (NSString*) getErrorForCode :(NSString*)code;

/**
 Get error for status
 
 @param status Status value
 @return Error description
 */
+ (NSString*) getErrorForStatus:(int)status;

/**
 Validates transaction type enum
 
 @param value Value to validate
 @return True if valid
 */
+ (BOOL)validateTransactionTypeEnumWithValue:(enum TransactionType)value;

/**
 Validates terminal decision enum
 
 @param value Value to validate
 @return True if valid
 */
+ (BOOL)validateTerminalDecisionEnumWithValue:(enum TerminalDecision)value;

/**
 Validates transaction response enum
 
 @param value Value to validate
 @return True if valid
 */
+ (BOOL)validateTransactionResponseEnumWithValue:(enum TransactionResponse)value;

/**
 Validates cryptogram type enum
 
 @param value Value to validate
 @return True if valid
 */
+ (BOOL)validateCryptogramTypeEnumWithValue:(enum CryptogramType)value;

/**
 Gets string value from enum TransactionType
 
 @param value Value to get string value
 @return String value of enum
 */
+ (NSString*)transactionTypeEnumStringWithValue:(enum TransactionType)value;

/**
 Extract tokens from specified data
 
 @param data Data with one or many tokens
 @return Array with found tokens
 */
+ (NSArray*) getTokens:(NSData*)data;

/**
 Get token length of specified type
 
 @param identifier Token identifier
 @param isPin Indicates if a pin was used
 @return Length of token
 */
+ (NSInteger) getTokenLength:(NSString*)identifier withPin:(BOOL)isPin;

/**
 Find a token with specified identifier in an array of tokens
 
 @param identifier Identifier to search
 @param array Array of tokens to search in
 @return if found a token, otherwise nil
 */
+ (NSData*) findTokenWithIdentifier:(NSString*)identifier andInArray:(NSArray*)array;

/**
 Validates a token with corresponding identifier
 
 @param token Token data
 @param identifier Token identifier
 @return True if token is valid
 */
+ (BOOL) validateToken:(NSData*)token withIdentifier:(NSString*)identifier;

@end


@implementation EvoUtils

static NSDictionary *errorCodes;

/**
 Converts hexadecimal string to a MutableData
 
 @param hexString Hexadecimal string
 @return Mutable data
 */
+ (NSMutableData*)dataWithHexString:(NSString*)hexString {
    NSMutableData *data = [[NSMutableData alloc] init];
    unsigned char wholeByte;
    char byteChars[3] = { '\0', '\0', '\0' };
    for (int x1 = 0; x1 < [hexString length] / 2; x1++) {
        byteChars[0] = [hexString characterAtIndex:x1 * 2];
        byteChars[1] = [hexString characterAtIndex:x1 * 2 + 1];
        wholeByte = strtol(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}

/**
 Converts data to hexadecimal string
 
 @param data data to convert
 @return Hexadecimal string
 */
+ (NSString*)hexStringWithData:(NSData*)data {
    const unsigned char *dataBuffer = (const unsigned char *)data.bytes;
    if (!dataBuffer) return [NSString string];
    NSUInteger dataLenght = data.length;
    NSMutableString *hexString = [NSMutableString stringWithCapacity:dataLenght * 2];
    
    for (int x1 = 0; x1 < dataLenght; ++x1) {
        [hexString appendFormat:@"%02lx", (unsigned long)dataBuffer[x1]];
    }
    
    return [NSString stringWithString:hexString];
}

/**
 Calculates the Longitudinal Redundancy Check (LCR) for specified data
 
 @param data Data to calculate LCR
 @return LCR
 */
+ (char)calculateLcrForData:(NSData*)data {
    char result = '\0';
    char *dataBytes = (char*)data.bytes;
    for (int x1 = 1; x1 < data.length; x1++) {
        result = result ^ dataBytes[x1];
    }
    return result;
}

/**
 Loads error codes file
 */
+ (void) loadErrorCodes {
    NSString *fileName = [[NSBundle bundleForClass:EvoUtils.class] pathForResource:@"ErrorCodes" ofType:@"strings"];
    if (fileName) {
        errorCodes = [NSDictionary dictionaryWithContentsOfFile:fileName];
        NSLog(@"%@", [self getErrorForCode:@"200"]);
    } else {
        NSLog(@"Error loading error codes");
    }
}

/**
 Get error text for specified code
 
 @param code Code of error
 @return Text description of error
 */
+ (NSString*) getErrorForCode :(NSString*)code {
    if (!errorCodes) return [NSString string];
    NSString *error = [errorCodes objectForKey:code];
    if (!error) {
        error = SYSTEM_ERROR_MESSAGE;
    }
    return error;
}

/**
 Get error for status
 
 @param status Status value
 @return Error description
 */
+ (NSString*) getErrorForStatus:(int)status {
    NSString* code = [NSString stringWithFormat:@"%02d", status];
    NSString* error = [EvoUtils getErrorForCode:code];
    if (!error) {
        error = VMF_API_ERROR_MESSAGE;
    }
    return error;
}

/**
 Validates transaction type enum
 
 @param value Value to validate
 @return True if valid
 */
+ (BOOL)validateTransactionTypeEnumWithValue:(enum TransactionType)value {
    BOOL isValid = FALSE;
    switch (value) {
        case Purchase:
        case CashAdvance:
        case CorrespondentRetreat:
        case PurchaseWithPIN:
        case QPS:
        case PurchaseWithCashBack:
        case Refund:
        case PaymentDeposit:
        case Authorization:
            isValid = TRUE;
            break;
        default:
            break;
    }
    return isValid;
}

/**
 Validates terminal decision enum
 
 @param value Value to validate
 @return True if valid
 */
+ (BOOL)validateTerminalDecisionEnumWithValue:(enum TerminalDecision)value {
    BOOL isValid = FALSE;
    switch (value) {
        case NoDecision:
        case ForcedOnline:
        case ForcedOffline:
        case ForcedDecline:
            isValid = TRUE;
            break;
        default:
            break;
    }
    return isValid;
}

/**
 Validates transaction response enum
 
 @param value Value to validate
 @return True if valid
 */
+ (BOOL)validateTransactionResponseEnumWithValue:(enum TransactionResponse)value {
    BOOL isValid = FALSE;
    switch (value) {
        case Authorized:
        case Declined:
        case CommunicationsError:
            isValid = TRUE;
            break;
        default:
            break;
    }
    return isValid;
}

/**
 Validates cryptogram type enum
 
 @param value Value to validate
 @return True if valid
 */
+ (BOOL)validateCryptogramTypeEnumWithValue:(enum CryptogramType)value {
    BOOL isValid = FALSE;
    switch (value) {
        case AAC:
        case TC:
        case ARQC:
        case AAR:
            isValid = TRUE;
            break;
        default:
            break;
    }
    return isValid;
}

/**
 Gets string value from enum TransactionType
 
 @param value Value to get string value
 @return String value of enum
 */
+ (NSString*)transactionTypeEnumStringWithValue:(enum TransactionType)value {
    NSString* description = nil;
    switch (value) {
        case Purchase:
            description = @"Compra";
            break;
        case CashAdvance:
            description = @"Cash advance";
            break;
        case CorrespondentRetreat:
            description = @"Retiro corresponsal";
            break;
        case PurchaseWithPIN:
            description = @"Compra con PIN";
            break;
        case QPS:
            description = @"QPS";
            break;
        case PurchaseWithCashBack:
            description = @"Compra con cashback";
            break;
        case Refund:
            description = @"Devolución";
            break;
        case PaymentDeposit:
            description = @"Deposito/Pago";
            break;
        case Authorization:
            description = @"Autorización";
            break;
        default:
            break;
    }
    return description;
}

/**
 Extract tokens from specified data
 
 @param data Data with one or many tokens
 @return Array with found tokens
 */
+ (NSArray*) getTokens:(NSData*)data {
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    const unsigned char *dataBuffer = (const unsigned char *)data.bytes;
    if (dataBuffer) {
        NSUInteger dataLenght = data.length;
        NSUInteger start = -1;
        for (NSUInteger x1 = 0; x1 < dataLenght; x1++) {
            if (dataBuffer[x1] == EYE_CATCHER) {
                if (start == -1) {
                    start = x1;
                } else {
                    NSInteger end = x1 - start;
                    [resultArray addObject:[data subdataWithRange:NSMakeRange(start, end)]];
                    start = x1;
                }
            }
        }
        NSInteger end = dataLenght - start;
        [resultArray addObject:[data subdataWithRange:NSMakeRange(start, end)]];
    }
    return resultArray;
}

/**
 Get token length of specified type
 
 @param identifier Token identifier
 @param isPin Indicates if a pin was used
 @return Length of token
 */
+ (NSInteger) getTokenLength:(NSString*)identifier withPin:(BOOL)isPin {
    NSInteger result = 0;
    if ([identifier isEqualToString:TOKEN_ES]) {
        result = TOKEN_ES_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_EW]) {
        result = TOKEN_EW_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_EX]) {
        result = TOKEN_EX_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_ET]) {
        result = TOKEN_ET_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_B2]) {
        result = TOKEN_B2_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_B3]) {
        result = TOKEN_B3_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_B4]) {
        result = TOKEN_B4_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_Q8]) {
        result = TOKEN_Q8_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_Q9] && !isPin) {
        result = TOKEN_Q9_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_Q9] && isPin) {
        result = TOKEN_Q9_PIN_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_EY]) {
        result = TOKEN_EY_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_EZ]) {
        result = TOKEN_EZ_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_C0]) {
        result = TOKEN_C0_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_QE]) {
        result = TOKEN_QE_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_B5]) {
        result = TOKEN_B5_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_B6]) {
        result = TOKEN_B6_LENGTH;
    } else if ([identifier isEqualToString:TOKEN_CZ]) {
        result = TOKEN_CZ_LENGTH;
    }
    return result;
}


/**
 Find a token with specified identifier in an array of tokens
 
 @param identifier Identifier to search
 @param array Array of tokens to search in
 @return if found a token, otherwise nil
 */
+ (NSData*) findTokenWithIdentifier:(NSString*)identifier andInArray:(NSArray*)array {
    if (array == nil) {
        return nil;
    }
    for (NSData* token in array) {
        if ([EvoUtils validateToken:token withIdentifier:nil]) {
            NSData* tokenIdData = [token subdataWithRange:NSMakeRange(2, 2)];
            NSString* tokenId = [[NSString alloc] initWithData:tokenIdData encoding:NSUTF8StringEncoding];
            if ([tokenId isEqualToString:identifier]) {
                return token;
            }
        }
    }
    return nil;
}

/**
 Validates a token with corresponding identifier
 
 @param token Token data
 @param identifier Token identifier
 @return True if token is valid
 */
+ (BOOL) validateToken:(NSData*)token withIdentifier:(NSString*)identifier {
    BOOL response = TRUE;
    int tokenLength = 0;
    
    const unsigned char *dataBuffer = (const unsigned char *)token.bytes;
    if (dataBuffer == nil)
        response = FALSE;
    if (response && dataBuffer[0] != EYE_CATCHER)
        response = FALSE;
    if (response && dataBuffer[1] != SEPARATOR)
        response = FALSE;
    if (response) {
        NSData* tokenIdData = [token subdataWithRange:NSMakeRange(2, 2)];
        NSString* tokenId = [[NSString alloc] initWithData:tokenIdData encoding:NSUTF8StringEncoding];
        if (identifier != nil) {
            if (![tokenId isEqualToString:identifier]) {
                response = FALSE;
            }
        } else {
            identifier = tokenId;
        }
    }
    
    NSInteger tokenValidLength = [EvoUtils getTokenLength:identifier withPin:false];
    NSInteger tokenValidPinLength = [EvoUtils getTokenLength:identifier withPin:true];
    
    if (tokenValidLength == 0 || tokenValidPinLength == 0) {
        response = FALSE;
    }
    
    if (response) {
        NSData* tokenLengthData = [token subdataWithRange:NSMakeRange(4, 5)];
        NSString* tokenLengthStr = [[NSString alloc] initWithData:tokenLengthData encoding:NSUTF8StringEncoding];
        tokenLength = [tokenLengthStr intValue];
        if (tokenLength != tokenValidLength && tokenLength != tokenValidPinLength)
            response = FALSE;
    }
    
    if (response && dataBuffer[9] != SEPARATOR)
        response = FALSE;
    
    if (response) {
        NSData* data = [token subdataWithRange:NSMakeRange(10, [token length] - 10)];
        if ([data length] != tokenLength)
            response = FALSE;
    }
    
    return response;
}

@end

#endif
