//
//  BBDeviceController.h
//  BBDeviceAPI
//
//  Created by Alex Wong on 2017-08-18.
//  Copyright © 2018 BBPOS Limited. All rights reserved.
//  RESTRICTED DOCUMENT
//

#import <Foundation/Foundation.h>
#import "CAPK.h"
#import "VASMerchantConfig.h"

//For iOS
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <ExternalAccessory/ExternalAccessory.h>

//For macOS
//#import <AppKit/AppKit.h>
//#import <IOBluetooth/IOBluetooth.h>
//#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM (NSUInteger, BBDeviceControllerState) {
    BBDeviceControllerState_CommLinkUninitialized,
    BBDeviceControllerState_Idle,
    BBDeviceControllerState_WaitingForResponse
};

typedef NS_ENUM (NSUInteger, BBDeviceBatteryStatus) {
    BBDeviceBatteryStatus_Low,
    BBDeviceBatteryStatus_CriticallyLow
};

typedef NS_ENUM (NSUInteger, BBDeviceConnectionMode) {
    BBDeviceConnectionMode_None,
    BBDeviceConnectionMode_Audio,
    BBDeviceConnectionMode_Bluetooth,
    BBDeviceConnectionMode_USB,
};

typedef NS_ENUM (NSUInteger, BBDeviceEmvOption) {
    BBDeviceEmvOption_Start,
    BBDeviceEmvOption_StartWithForceOnline
};

typedef NS_ENUM (NSUInteger, BBDeviceCheckCardResult) {
    BBDeviceCheckCardResult_NoCard,
    BBDeviceCheckCardResult_InsertedCard,
    BBDeviceCheckCardResult_NotIccCard,
    BBDeviceCheckCardResult_BadSwipe,
    BBDeviceCheckCardResult_SwipedCard,
    BBDeviceCheckCardResult_MagHeadFail,
    BBDeviceCheckCardResult_UseIccCard,
    BBDeviceCheckCardResult_TapCardDetected,
    BBDeviceCheckCardResult_ManualPanEntry
};

typedef NS_ENUM (NSUInteger, BBDeviceErrorType) {
    BBDeviceErrorType_InvalidInput,
    BBDeviceErrorType_InvalidInput_NotNumeric,
    BBDeviceErrorType_InvalidInput_InputValueOutOfRange,
    BBDeviceErrorType_InvalidInput_InvalidDataFormat,
    BBDeviceErrorType_InvalidInput_NotAcceptAmountForThisTransactionType,
    BBDeviceErrorType_InvalidInput_NotAcceptCashbackForThisTransactionType,
    
    BBDeviceErrorType_Unknown,
    BBDeviceErrorType_IllegalStateException,
    
    BBDeviceErrorType_CommError,
    BBDeviceErrorType_CommandNotAvailable,
    BBDeviceErrorType_DeviceBusy,
    
    BBDeviceErrorType_CommLinkUninitialized,
    BBDeviceErrorType_InvalidFunctionInCurrentConnectionMode,
    
    BBDeviceErrorType_AudioFailToStart,
    BBDeviceErrorType_AudioFailToStart_OtherAudioIsPlaying,
    BBDeviceErrorType_AudioRecordingPermissionDenied,
    BBDeviceErrorType_AudioBackgroundTimeout,
    
    BBDeviceErrorType_BTv4NotSupported,
    BBDeviceErrorType_BTFailToStart,
    BBDeviceErrorType_BTAlreadyConnected,
    
    BBDeviceErrorType_HardwareNotSupported, //Firmware supported but hardware not supported
    BBDeviceErrorType_PCIError,
    
    BBDeviceErrorType_BLESecureConnectionNotSupported, //BT 4.2
    BBDeviceErrorType_PairingError,
    BBDeviceErrorType_PairingError_IncorrectPasskey,
    BBDeviceErrorType_PairingError_AlreadyPairedWithAnotherDevice,
    
};

typedef NS_ENUM (NSUInteger, BBDeviceTransactionResult) {
    BBDeviceTransactionResult_Approved,
    BBDeviceTransactionResult_Terminated,
    BBDeviceTransactionResult_Declined,
    BBDeviceTransactionResult_CanceledOrTimeout,
    BBDeviceTransactionResult_CapkFail,
    BBDeviceTransactionResult_NotIcc,
    BBDeviceTransactionResult_CardBlocked,
    BBDeviceTransactionResult_DeviceError,
    BBDeviceTransactionResult_SelectApplicationFail,
    BBDeviceTransactionResult_CardNotSupported,
    BBDeviceTransactionResult_MissingMandatoryData,
    BBDeviceTransactionResult_NoEmvApps,
    BBDeviceTransactionResult_InvalidIccData,
    BBDeviceTransactionResult_ConditionsOfUseNotSatisfied,
    BBDeviceTransactionResult_ApplicationBlocked,
    BBDeviceTransactionResult_IccCardRemoved,
    BBDeviceTransactionResult_CardSchemeNotMatched,
    BBDeviceTransactionResult_Canceled,
    BBDeviceTransactionResult_Timeout
};

typedef NS_ENUM (NSUInteger, BBDeviceTransactionType) {
    BBDeviceTransactionType_Goods,
    BBDeviceTransactionType_Services,
    BBDeviceTransactionType_Cashback,
    BBDeviceTransactionType_Inquiry,
    BBDeviceTransactionType_Transfer,
    BBDeviceTransactionType_Payment,
    BBDeviceTransactionType_Refund,
    BBDeviceTransactionType_Void,
    BBDeviceTransactionType_Reversal,
    BBDeviceTransactionType_Cash
};

typedef NS_ENUM (NSUInteger, BBDeviceDisplayText) {
    BBDeviceDisplayText_APPROVED,
    BBDeviceDisplayText_CALL_YOUR_BANK,
    BBDeviceDisplayText_DECLINED,
    BBDeviceDisplayText_ENTER_AMOUNT,
    BBDeviceDisplayText_ENTER_PIN,
    BBDeviceDisplayText_INCORRECT_PIN,
    BBDeviceDisplayText_INSERT_CARD,
    BBDeviceDisplayText_NOT_ACCEPTED,
    BBDeviceDisplayText_PIN_OK,
    BBDeviceDisplayText_PLEASE_WAIT,
    BBDeviceDisplayText_REMOVE_CARD,
    BBDeviceDisplayText_USE_MAG_STRIPE,
    BBDeviceDisplayText_TRY_AGAIN,
    BBDeviceDisplayText_REFER_TO_YOUR_PAYMENT_DEVICE,
    BBDeviceDisplayText_TRANSACTION_TERMINATED,
    BBDeviceDisplayText_PROCESSING,
    BBDeviceDisplayText_LAST_PIN_TRY,
    BBDeviceDisplayText_SELECT_ACCOUNT,
    BBDeviceDisplayText_PRESENT_CARD,
    BBDeviceDisplayText_APPROVED_PLEASE_SIGN,
    BBDeviceDisplayText_PRESENT_CARD_AGAIN,
    BBDeviceDisplayText_AUTHORISING,
    BBDeviceDisplayText_INSERT_SWIPE_OR_TRY_ANOTHER_CARD,
    BBDeviceDisplayText_INSERT_OR_SWIPE_CARD,
    BBDeviceDisplayText_MULTIPLE_CARDS_DETECTED,
    BBDeviceDisplayText_TIMEOUT,
    BBDeviceDisplayText_APPLICATION_EXPIRED,
    BBDeviceDisplayText_FINAL_CONFIRM,
    BBDeviceDisplayText_SHOW_THANK_YOU,
    BBDeviceDisplayText_PIN_TRY_LIMIT_EXCEEDED,
    BBDeviceDisplayText_NOT_ICC_CARD,
    BBDeviceDisplayText_CARD_INSERTED,
    BBDeviceDisplayText_CARD_REMOVED,
    BBDeviceDisplayText_NO_EMV_APPS
};

typedef NS_ENUM (NSUInteger, BBDeviceTerminalSettingStatus) {
    BBDeviceTerminalSettingStatus_Success,
    BBDeviceTerminalSettingStatus_InvalidTlvFormat,
    BBDeviceTerminalSettingStatus_TagNotFound,
    BBDeviceTerminalSettingStatus_InvalidLength,
    BBDeviceTerminalSettingStatus_BootLoaderNotSupported,
    BBDeviceTerminalSettingStatus_TagNotAllowedToAccess,
    BBDeviceTerminalSettingStatus_TagNotWrittenCorrectly,
    BBDeviceTerminalSettingStatus_InvalidValue
};

typedef NS_ENUM (NSUInteger, BBDeviceCheckCardMode) {
    BBDeviceCheckCardMode_Swipe,
    BBDeviceCheckCardMode_Insert,
    BBDeviceCheckCardMode_Tap,
    BBDeviceCheckCardMode_SwipeOrInsert,
    BBDeviceCheckCardMode_SwipeOrTap,
    BBDeviceCheckCardMode_SwipeOrInsertOrTap,
    BBDeviceCheckCardMode_InsertOrTap,
    BBDeviceCheckCardMode_ManualPanEntry,
    BBDeviceCheckCardMode_QRCode
};

/*
 typedef NS_ENUM (NSUInteger, BBDeviceTerminalCapabilities) {
 BBDeviceTerminalCapabilities_1C,
 BBDeviceTerminalCapabilities_2C,
 BBDeviceTerminalCapabilities_3C,
 BBDeviceTerminalCapabilities_4C
 };
 */

typedef NS_ENUM (NSUInteger, BBDeviceEncryptionMethod) {
    BBDeviceEncryptionMethod_TDES_ECB,
    BBDeviceEncryptionMethod_TDES_CBC,
    BBDeviceEncryptionMethod_AES_ECB,
    BBDeviceEncryptionMethod_AES_CBC,
    BBDeviceEncryptionMethod_MAC_ANSI_X9_9,
    BBDeviceEncryptionMethod_MAC_ANSI_X9_19,
    BBDeviceEncryptionMethod_MAC_METHOD_1,
    BBDeviceEncryptionMethod_MAC_METHOD_2
};

typedef NS_ENUM (NSUInteger, BBDeviceEncryptionKeySource) {
    BBDeviceEncryptionKeySource_BY_DEVICE_16_BYTES_RANDOM_NUMBER,
    BBDeviceEncryptionKeySource_BY_DEVICE_8_BYTES_RANDOM_NUMBER,
    BBDeviceEncryptionKeySource_BOTH,
    BBDeviceEncryptionKeySource_BY_SERVER_16_BYTES_WORKING_KEY,
    BBDeviceEncryptionKeySource_BY_SERVER_8_BYTES_WORKING_KEY,
    BBDeviceEncryptionKeySource_STORED_IN_DEVICE_16_BYTES_KEY
};

typedef NS_ENUM (NSUInteger, BBDeviceEncryptionPaddingMethod) {
    BBDeviceEncryptionPaddingMethod_ZERO_PADDING,
    BBDeviceEncryptionPaddingMethod_PKCS7
};

typedef NS_ENUM (NSUInteger, BBDeviceEncryptionKeyUsage) {
    BBDeviceEncryptionKeyUsage_TEK,
    BBDeviceEncryptionKeyUsage_TAK,
    BBDeviceEncryptionKeyUsage_TPK
};

typedef NS_ENUM (NSUInteger, BBDevicePinEntryResult) {
    BBDevicePinEntryResult_PinEntered,
    BBDevicePinEntryResult_Cancel,
    BBDevicePinEntryResult_Timeout,
    BBDevicePinEntryResult_ByPass,
    BBDevicePinEntryResult_IncorrectPinLength,
    BBDevicePinEntryResult_IncorrectPin
};

typedef NS_ENUM (NSUInteger, BBDeviceCurrencyCharacter) {
    BBDeviceCurrencyCharacter_A, BBDeviceCurrencyCharacter_B, BBDeviceCurrencyCharacter_C, BBDeviceCurrencyCharacter_D, BBDeviceCurrencyCharacter_E,
    BBDeviceCurrencyCharacter_F, BBDeviceCurrencyCharacter_G, BBDeviceCurrencyCharacter_H, BBDeviceCurrencyCharacter_I, BBDeviceCurrencyCharacter_J,
    BBDeviceCurrencyCharacter_K, BBDeviceCurrencyCharacter_L, BBDeviceCurrencyCharacter_M, BBDeviceCurrencyCharacter_N, BBDeviceCurrencyCharacter_O,
    BBDeviceCurrencyCharacter_P, BBDeviceCurrencyCharacter_Q, BBDeviceCurrencyCharacter_R, BBDeviceCurrencyCharacter_S, BBDeviceCurrencyCharacter_T,
    BBDeviceCurrencyCharacter_U, BBDeviceCurrencyCharacter_V, BBDeviceCurrencyCharacter_W, BBDeviceCurrencyCharacter_X, BBDeviceCurrencyCharacter_Y,
    BBDeviceCurrencyCharacter_Z,
    BBDeviceCurrencyCharacter_Space,
    
    BBDeviceCurrencyCharacter_Dirham,
    BBDeviceCurrencyCharacter_Dollar,
    BBDeviceCurrencyCharacter_Euro,
    BBDeviceCurrencyCharacter_IndianRupee,
    BBDeviceCurrencyCharacter_Pound,
    BBDeviceCurrencyCharacter_SaudiRiyal,
    BBDeviceCurrencyCharacter_SaudiRiyal2,
    BBDeviceCurrencyCharacter_Won,
    BBDeviceCurrencyCharacter_Yen,
    BBDeviceCurrencyCharacter_SlashAndDot,
    BBDeviceCurrencyCharacter_Dot,
    BBDeviceCurrencyCharacter_Yuan,
    BBDeviceCurrencyCharacter_NewShekel
};

typedef NS_ENUM (NSUInteger, BBDeviceAmountInputType) {
    BBDeviceAmountInputType_AmountOnly,
    BBDeviceAmountInputType_AmountAndCashback,
    BBDeviceAmountInputType_CashbackOnly,
    BBDeviceAmountInputType_TipsOnly,
    BBDeviceAmountInputType_AmountAndTips,
    BBDeviceAmountInputType_AmountAndTipsInPercentage
};

typedef NS_ENUM (NSUInteger, BBDevicePinEntrySource) {
    BBDevicePinEntrySource_Phone,
    BBDevicePinEntrySource_Keypad
};

typedef NS_ENUM (NSUInteger, BBDeviceCardScheme) {
    BBDeviceCardScheme_Visa,
    BBDeviceCardScheme_Master,
    BBDeviceCardScheme_UnionPay
};

typedef NS_ENUM (NSUInteger, BBDeviceSessionError) {
    BBDeviceSessionError_FirmwareNotSupported,
    BBDeviceSessionError_SessionNotInitialized,
    BBDeviceSessionError_InvalidVendorToken,
    BBDeviceSessionError_InvalidSession
};

typedef NS_ENUM (NSUInteger, BBDeviceNfcDetectCardResult) {
    BBDeviceNfcDetectCardResult_WaitingForCard,
    BBDeviceNfcDetectCardResult_WaitingCardRemoval,
    BBDeviceNfcDetectCardResult_CardDetected,
    BBDeviceNfcDetectCardResult_CardRemoved,
    BBDeviceNfcDetectCardResult_Timeout,
    BBDeviceNfcDetectCardResult_CardNotSupported,
    BBDeviceNfcDetectCardResult_MultipleCardDetected
};

typedef NS_ENUM (NSUInteger, BBDeviceNfcReadNdefRecord) {
    BBDeviceNfcReadNdefRecord_ReadFirst,
    BBDeviceNfcReadNdefRecord_ReadNext
};

typedef NS_ENUM (NSUInteger, BBDevicePrintResult) {
    BBDevicePrintResult_Success,
    BBDevicePrintResult_NoPaperOrCoverOpened,
    BBDevicePrintResult_WrongPrinterCommand,
    BBDevicePrintResult_Overheat,
    BBDevicePrintResult_PrinterError
};

typedef NS_ENUM (NSUInteger, BBDevicePhoneEntryResult) {
    BBDevicePhoneEntryResult_Entered,
    BBDevicePhoneEntryResult_Timeout,
    BBDevicePhoneEntryResult_WrongLength,
    BBDevicePhoneEntryResult_Cancel,
    BBDevicePhoneEntryResult_Bypass
};

typedef NS_ENUM (NSUInteger, BBDeviceAccountSelectionResult) {
    BBDeviceAccountSelectionResult_Success,
    BBDeviceAccountSelectionResult_Canceled,
    BBDeviceAccountSelectionResult_Timeout,
    BBDeviceAccountSelectionResult_InvalidSelection
};

typedef NS_ENUM (NSUInteger, BBDeviceLEDMode) {
    BBDeviceLEDMode_Default,
    BBDeviceLEDMode_On,
    BBDeviceLEDMode_Off,
    BBDeviceLEDMode_Flash
};

typedef NS_ENUM (NSUInteger, BBDeviceVASTerminalMode) {
    BBDeviceVASTerminalMode_VAS,
    BBDeviceVASTerminalMode_Dual,
    BBDeviceVASTerminalMode_Single,
    BBDeviceVASTerminalMode_Payment
};

typedef NS_ENUM (NSUInteger, BBDeviceVASProtocolMode) {
    BBDeviceVASProtocolMode_URL,
    BBDeviceVASProtocolMode_Full
};

typedef NS_ENUM (NSUInteger, BBDeviceVASResult) {
    BBDeviceVASResult_Success,
    BBDeviceVASResult_VASDataNotFound,
    BBDeviceVASResult_VASDataNotActivated,
    BBDeviceVASResult_UserInterventionRequired,
    BBDeviceVASResult_IncorrectData,
    BBDeviceVASResult_UnsupportedAppVersion,
    BBDeviceVASResult_NonVASCardDetected
};

typedef NS_ENUM (NSUInteger, BBDeviceDisplayPromptOption) {
    BBDeviceDisplayPromptOption_DisplayOnly,
    BBDeviceDisplayPromptOption_DisplayWithConfirmButtons,
    BBDeviceDisplayPromptOption_DisplayOnlyWithoutTimeout
};

typedef NS_ENUM (NSUInteger, BBDeviceDisplayPromptResult) {
    BBDeviceDisplayPromptResult_ConfirmButtonPressed,
    BBDeviceDisplayPromptResult_CancelButtonPressed,
    BBDeviceDisplayPromptResult_CancelledByCommand,
    BBDeviceDisplayPromptResult_ButtonConfirmationTimeout,
    BBDeviceDisplayPromptResult_DisplayEnd
};

// SPoC
typedef NS_ENUM (NSUInteger, BBDeviceSPoCError) {
    BBDeviceSPoCError_Unknown,
    BBDeviceSPoCError_NotSCRPDevice,
    BBDeviceSPoCError_NoNetworkConnection,
    BBDeviceSPoCError_COTSDeviceNotSupported,
    BBDeviceSPoCError_DebuggerDetected,
    BBDeviceSPoCError_RequiredSDKUpdate,
    BBDeviceSPoCError_RequiredFirmwareUpdate,
    BBDeviceSPoCError_LocationServiceIsDisabled,
    BBDeviceSPoCError_SetupError,
    BBDeviceSPoCError_ServerCommError,
    BBDeviceSPoCError_SecureChannelError,
    BBDeviceSPoCError_AttestationFailed,
    BBDeviceSPoCError_PinPadLostFocus,
    BBDeviceSPoCError_SCRPDeviceTampered,
    BBDeviceSPoCError_SCRPDeviceAndAppPairNotMatch,
    BBDeviceSPoCError_AppDecommissioned,
};

@protocol BBDeviceControllerDelegate;

@interface BBDeviceController : NSObject {
    NSObject <BBDeviceControllerDelegate>* delegate;
    
    BOOL debugLogEnabled;
    BOOL detectAudioDevicePlugged;
}

@property (nonatomic, weak) NSObject <BBDeviceControllerDelegate>* delegate;
@property (nonatomic, getter=isDebugLogEnabled, setter=setDebugLogEnabled:) BOOL debugLogEnabled;
@property (nonatomic, getter=isDetectAudioDevicePlugged, setter=setDetectAudioDevicePlugged:) BOOL detectAudioDevicePlugged;

+ (BBDeviceController *)sharedController;
- (BBDeviceControllerState)getBBDeviceControllerState;
- (void)releaseBBDeviceController;

// ----------------------------------------- API Version -----------------------------------------------

- (NSString *)getApiVersion;
- (NSString *)getApiBuildNumber;

// ----------------------------------------- Communication Channel -----------------------------------------------

- (void)isDeviceHere;    //Send out a detect command to check the device is valid
- (BOOL)isAudioDevicePlugged;
- (BBDeviceConnectionMode)getConnectionMode;

// Communication Channel - Audio
- (BOOL)startAudio;
- (void)stopAudio;

// Communication Channel - BT
- (void)startBTScan:(NSArray *)deviceNameArray scanTimeout:(int)scanTimeout;
- (void)stopBTScan;
- (void)connectBT:(NSObject *)device;                       //EAAccessory or CBPeripheral object
- (void)connectBTWithUUID:(NSString *)UUID;                 //For BT4 only, not for BT2
- (void)disconnectBT;
- (NSString *)getPeripheralUUID:(CBPeripheral *)peripheral; //For BT4 only, not for BT2

// Communication Channel - USB (For macOS, not for iOS)
- (void)startUsb;
- (void)stopUsb;

// ----------------------------------------- Session Token -----------------------------------------------

- (BOOL)isSessionInitialized;
- (void)initSession:(NSString *)vendorToken;
- (void)resetSession;

// ----------------------------------------- Device Info -----------------------------------------------

- (void)getDeviceInfo;

// ----------------------------------------- Power Down -----------------------------------------------

- (void)powerDown;

// ----------------------------------------- Standby Mode -----------------------------------------------

- (void)enterStandbyMode;

// ----------------------------------------- LED -----------------------------------------------

- (void)controlLED:(NSDictionary *)data;

// ----------------------------------------- Utility -----------------------------------------------

- (NSString *)encodeTlv:(NSDictionary *)data;
- (NSDictionary *)decodeTlv:(NSString *)tlv;

// ----------------------------------------- Transaction -----------------------------------------------

// Start Transaction
- (void)startEmvWithData:(NSDictionary *)data;

// Request Terminal Time
- (void)sendTerminalTime:(NSString *)terminalTime;

// Request Set Amount
- (BOOL)setAmount:(NSDictionary *)data;
- (BOOL)setAmount:(NSString *)amount
   cashbackAmount:(NSString *)cashbackAmount
     currencyCode:(NSString *)currencyCode
  transactionType:(BBDeviceTransactionType)transactionType
currencyCharacters:(NSArray *)currencyCharacters;
- (void)cancelSetAmount; //Cancel transaction at onRequestSetAmount

// Waiting for card
- (void)cancelCheckCard;

// Request Select Application
- (void)selectApplication:(int)applicationIndex;
- (void)cancelSelectApplication; //Cancel transaction at onRequestSelectApplication

// Request Final Confirm
- (void)sendFinalConfirmResult:(BOOL)isConfirmed;
- (void)sendFinalConfirmResult:(BOOL)isConfirmed withData:(NSString *)tlv;

// Request Online Process
- (void)sendOnlineProcessResult:(NSString *)tlv;

// Set Amount on device with keypad before startEmv
- (void)enableInputAmount:(NSDictionary *)data;
- (void)disableInputAmount;

// PIN entry on device with keypad
- (void)startPinEntry:(NSDictionary *)data; // start PIN entry mode only available after swiped card
- (void)cancelPinEntry; //Cancel transaction at onRequestPinEntry

// PIN entry on App for device with PBOC firmware
- (void)sendPinEntryResult:(NSString *)pin;
- (void)bypassPinEntry;

// ----------------------------------------- Check Card Data -----------------------------------------------

- (void)checkCard:(NSDictionary *)data;
- (void)getEmvCardData;
- (void)getEmvCardNumber;

// ----------------------------------------- Data Encryption -----------------------------------------------

- (void)encryptPin:(NSDictionary *)data;
- (void)encryptDataWithSettings:(NSDictionary *)data;

// ----------------------------------------- Contact Card -----------------------------------------------

- (void)powerOnIcc:(NSDictionary *)data;
- (void)powerOffIcc;
- (void)sendApdu:(NSDictionary *)data;

// ----------------------------------------- Contactless Card -----------------------------------------------

- (void)startNfcDetection:(NSDictionary *)data;
- (void)stopNfcDetection:(NSDictionary *)data;
- (void)nfcDataExchange:(NSDictionary *)data;

// ----------------------------------------- Terminal Settings -----------------------------------------------

// Terminal Setting
- (void)readTerminalSetting:(NSString *)dol;
- (void)updateTerminalSetting:(NSString *)tlv;

- (void)readAID:(NSString *)appIndex;
- (void)updateAID:(NSDictionary *)data;

// CAPK
- (void)getCAPKList;
- (void)getCAPKDetail:(NSString *)location;
- (void)findCAPKLocation:(NSDictionary *)data;
- (void)updateCAPK:(CAPK *)capk;
- (void)removeCAPK:(NSDictionary *)data;
- (void)getEmvReportList;
- (void)getEmvReport:(NSString *)applicationIndex;

// Standalone Mode
- (void)readWiFiSettings;
- (void)updateWiFiSettings:(NSDictionary *)settings;
- (void)readGprsSettings;
- (void)updateGprsSettings:(NSDictionary *)settings;

// ----------------------------------------- Printer (For WisePad 2 Plus) -----------------------------------------------

// Printing Command
- (void)startPrint:(int)numOfData reprintOrPrintNextTimeout:(int)reprintOrPrintNextTimeout;
- (void)sendPrintData:(NSData *)data;

// Printing Utility
- (NSString *)getBarcodeCommand:(NSDictionary *)barcodeData; //codeType accept 128 and 39 only
- (NSString *)getImageCommand:(NSObject *)image; //Max image width is 384 pixel. UIImage for iOS, NSImage for macOS
- (NSString *)getUnicodeCommand:(NSString *)data;

// ----------------------------------------- Account Selection -----------------------------------------------

- (void)enableAccountSelection:(NSDictionary *)data;
- (void)disableAccountSelection;

// ----------------------------------------- Display Prompt -----------------------------------------------

- (void)displayPrompt:(NSDictionary *)data;
- (void)cancelDisplayPrompt;

// ----------------------------------------- Other -----------------------------------------------

// Phone Number
- (void)startGetPhoneNumber;
- (void)cancelGetPhoneNumber;

// ----------------------------------------- Key Exchange -----------------------------------------------

- (void)injectSessionKey:(NSDictionary *)data;

// ----------------------------------------- SPOC -----------------------------------------------

// SPoC
- (void)setSPoCController:(NSObject *)controller;
- (void)setSPoCPinPadData:(NSDictionary *)data;
- (void)setupSPoCSecureSession:(NSDictionary *)data;

@end




// ========================================= BBDeviceControllerDelegate =========================================

@protocol BBDeviceControllerDelegate <NSObject>

@optional

// ----------------------------------------- Battery Warning -----------------------------------------------

- (void)onBatteryLow:(BBDeviceBatteryStatus)batteryStatus;

// ----------------------------------------- Error Handling -----------------------------------------------

- (void)onError:(BBDeviceErrorType)errorType errorMessage:(NSString *)errorMessage;

// ----------------------------------------- Power Button Event -----------------------------------------------

- (void)onPowerButtonPressed;
- (void)onDeviceReset;

// ----------------------------------------- Power Down Event -----------------------------------------------

- (void)onPowerDown;

// ----------------------------------------- Standby Mode -----------------------------------------------

- (void)onEnterStandbyMode;

// ----------------------------------------- LED -----------------------------------------------

- (void)onReturnControlLEDResult:(BOOL)isSuccess errorMessage:(NSString *)errorMessage;

// ----------------------------------------- Communication Channel -----------------------------------------------

// Communication Channel
- (void)onDeviceHere:(BOOL)isHere;

// Communication Channel - Audio
- (void)onAudioDevicePlugged;
- (void)onAudioDeviceUnplugged;
- (void)onAudioInterrupted;
- (void)onNoAudioDeviceDetected;

// Communication Channel - BT - BT2 or BT4
- (void)onBTScanStopped;
- (void)onBTScanTimeout;
- (void)onBTReturnScanResults:(NSArray *)devices;
- (void)onBTConnectTimeout;
- (void)onBTConnected:(NSObject *)connectedDevice;
- (void)onBTDisconnected;
- (void)onRequestEnableBluetoothInSettings;

// BT 4.2
- (void)onBTRequestPairing;

// Communication Channel - USB (For macOS, not for iOS)
- (void)onUsbConnected;
- (void)onUsbDisconnected;

// ----------------------------------------- Session Token -----------------------------------------------

- (void)onSessionInitialized;
- (void)onSessionReset;
- (void)onSessionError:(BBDeviceSessionError)sessionError errorMessage:(NSString *)errorMessage;

// ----------------------------------------- Device Info -----------------------------------------------

- (void)onReturnDeviceInfo:(NSDictionary *)deviceInfo;

// ----------------------------------------- Transaction -----------------------------------------------

// Start Transaction
- (void)onRequestTerminalTime;
- (void)onRequestSetAmount;
- (void)onRequestSelectApplication:(NSArray *)applicationArray;

// Confirm Amount on device with keypad after set amount
- (void)onReturnAmountConfirmResult:(BOOL)isConfirmed;

// Waiting for card
- (void)onWaitingForCard:(BBDeviceCheckCardMode)checkCardMode;

// Confirm Transaction
- (void)onRequestFinalConfirm;
- (void)onRequestOnlineProcess:(NSString *)tlv;
- (void)onReturnBatchData:(NSString *)tlv;
- (void)onReturnReversalData:(NSString *)tlv;
- (void)onReturnTransactionResult:(BBDeviceTransactionResult)result;

// DisplayText
- (void)onRequestDisplayText:(BBDeviceDisplayText)displayMessage;
- (void)onRequestClearDisplay;

// Set Amount on device with keypad before startEmv
- (void)onReturnEnableInputAmountResult:(BOOL)isSuccess;
- (void)onReturnDisableInputAmountResult:(BOOL)isSuccess;
- (void)onReturnAmount:(NSDictionary *)data;

// PIN entry on device with keypad or with PBOC firmware
- (void)onRequestPinEntry:(BBDevicePinEntrySource)pinEntrySource;
- (void)onReturnPinEntryResult:(BBDevicePinEntryResult)result data:(NSDictionary *)data;

// ----------------------------------------- Check Card Data -----------------------------------------------

- (void)onReturnCancelCheckCardResult:(BOOL)isSuccess;
- (void)onReturnCheckCardResult:(BBDeviceCheckCardResult)result cardData:(NSDictionary *)cardData;
- (void)onReturnEmvCardDataResult:(BOOL)isSuccess tlv:(NSString *)tlv;
- (void)onReturnEmvCardNumber:(BOOL)isSuccess cardNumber:(NSString *)cardNumber;

// ----------------------------------------- Data Encryption -----------------------------------------------

- (void)onReturnEncryptPinResult:(BOOL)isSuccess data:(NSDictionary *)data;
- (void)onReturnEncryptDataResult:(BOOL)isSuccess data:(NSDictionary *)data;

// ----------------------------------------- Contact Card -----------------------------------------------

- (void)onReturnPowerOnIccResult:(BOOL)isSuccess ksn:(NSString *)ksn atr:(NSString *)atr atrLength:(int)atrLength;
- (void)onReturnPowerOffIccResult:(BOOL)isSuccess;
- (void)onReturnApduResult:(BOOL)isSuccess data:(NSDictionary *)data;

// ----------------------------------------- Contactless Card -----------------------------------------------

- (void)onReturnNfcDetectCardResult:(BBDeviceNfcDetectCardResult)nfcDetectCardResult data:(NSDictionary *)data;
- (void)onReturnNfcDataExchangeResult:(BOOL)isSuccess data:(NSDictionary *)data;

// VAS
- (void)onReturnVASResult:(BBDeviceVASResult)result data:(NSDictionary *)data;
- (void)onRequestStartEmv;

// ----------------------------------------- Terminal Settings -----------------------------------------------

// Terminal Setting
//- (void)onReturnReadTerminalSettingResult:(BBDeviceTerminalSettingStatus)status tagValue:(NSString *)tagValue;
- (void)onReturnReadTerminalSettingResult:(NSDictionary *)data;
- (void)onReturnUpdateTerminalSettingResult:(BBDeviceTerminalSettingStatus)status;

- (void)onReturnReadAIDResult:(NSDictionary *)data;
- (void)onReturnUpdateAIDResult:(NSDictionary *)data;

// CAPK
- (void)onReturnCAPKList:(NSArray *)capkArray;
- (void)onReturnCAPKDetail:(CAPK *)capk;
- (void)onReturnCAPKLocation:(NSString *)location;
- (void)onReturnUpdateCAPKResult:(BOOL)isSuccess;
- (void)onReturnRemoveCAPKResult:(BOOL)isSuccess;
- (void)onReturnEmvReportList:(NSDictionary *)data;
- (void)onReturnEmvReport:(NSString *)tlv;

// Standalone Mode
- (void)onReturnReadWiFiSettingsResult:(BOOL)isSuccess data:(NSDictionary *)data;
- (void)onReturnUpdateWiFiSettingsResult:(BOOL)isSuccess data:(NSDictionary *)data;
- (void)onReturnReadGprsSettingsResult:(BOOL)isSuccess data:(NSDictionary *)data;
- (void)onReturnUpdateGprsSettingsResult:(BOOL)isSuccess data:(NSDictionary *)data;

// ----------------------------------------- Receipt Printing (For WisePad 2 Plus) -----------------------------------------------

- (void)onRequestPrintData:(int)index isReprint:(BOOL)isReprint;
- (void)onWaitingReprintOrPrintNext;
- (void)onReturnPrintResult:(BBDevicePrintResult)result;
- (void)onPrintDataEnd;
- (void)onPrintCancelled;

// ----------------------------------------- Account Selection -----------------------------------------------

- (void)onReturnEnableAccountSelectionResult:(BOOL)isSuccess;
- (void)onReturnDisableAccountSelectionResult:(BOOL)isSuccess;
- (void)onReturnAccountSelectionResult:(BBDeviceAccountSelectionResult)result selectedAccountType:(int)selectedAccountType;

// ----------------------------------------- Display Prompt -----------------------------------------------

- (void)onDeviceDisplayingPrompt;
- (void)onRequestKeypadResponse;
- (void)onReturnDisplayPromptResult:(BBDeviceDisplayPromptResult)result;

// ----------------------------------------- Other -----------------------------------------------

- (void)onReturnPhoneNumber:(BBDevicePhoneEntryResult)result phoneNumber:(NSString *)phoneNumber;

// ----------------------------------------- Key Exchange -----------------------------------------------

- (void)onReturnInjectSessionKeyResult:(BOOL)isSuccess data:(NSDictionary *)data;

// ----------------------------------------- SPOC -----------------------------------------------

// SPoC
- (void)onSPoCError:(BBDeviceSPoCError)errorType errorMessage:(NSString *)errorMessage;
- (void)onSPoCRequestSetupSecureSession;
- (void)onSPoCAttestationInProgress;
- (void)onSPoCSetupSecureSessionCompleted;



@end
