//
//  constants.h
//  PayLiquid
//
//  Created by Olexandr Skrypnyk on 12.03.13.
//  Copyright (c) 2013 PayLiquid. All rights reserved.
//

#import "AppDelegate.h"

#ifndef PayLiquid_constants_h
#define PayLiquid_constants_h

static NSInteger const currentDatabaseSchemaVersion = 1;

typedef enum {
  EImageTypeCatalogNone = 0,
  EImageTypeCatalogImage = 1,
  EImageTypeMerchantLogo = 2,
  EImageTypeSignature = 3,
  EImageTypeTransactionImage = 4,
  EImageTypeInvoiceSignature = 5,
} EImageType;

typedef enum {
  ERefundResponseTypeCompleted = 0,
  ERefundResponseTypeCardRequired = 1,
  ERefundResponseTypeAlreadyReversed = 2,
  ERefundResponseTypePaymentUnknown = 3,
  ERefundResponseTypeAmountInvalid = 4,
  ERefundResponseDeclinedAcquirer = 5,
  ERefundResponseErrorServer = 6,
} ERefundResponseType;

typedef enum {
  ECompletionResponseApproved = 0,
  ECompletionAbortedCardRemoved = 1,
  ECompletionAbortedCancelled = 2,
  ECompletionDeclinedOnlineOnly = 3,
  ECompletionDeclinedLocally = 4,
  ECompletionDeclinedIssuer = 5,
  ECompletionDeclinedTechError = 6,
  ECompletionDeclinedPinUnverified = 7,
  ECompletionDeclinedServerError = 8,
  ECompletionDeclinedByMerchant = 9,
  ECompletionDeclinedAppError = 10,
  ECompletionDeclinedLostCommsToPED = 99,
} ECompletionResponseType;

typedef enum EViewType{
  EViewTypeBillPayment = 0,
  EViewTypePaymentHistory = 1,
  EViewTypeCustomers = 2,
  EViewTypeProducts = 3,
  EViewTypeAnalytics = 4,
  EViewTypeMenu = 5,
} EViewType;

typedef enum ETransactionType{
  EPaymentTypeCash = 1,
  EPaymentTypeCard = 2,
  EPaymentTypeInvoice = 3,
  EPaymentTypeRefund = 4,
} ETransactionType;

typedef enum EPermissionsType {
  EPermTypeDefault      = 0,
  EPermTypeAcceptCash   = 1,
  EPermTypeAcceptCard   = 2,
  EPermTypeIssueRefund  = 3,
  EPermTypePayViewHist  = 4,
  EPermTypePayViewTrans = 5,
  EPermTypePayLinkCust  = 6,
  EPermTypePayResendRec = 7,
  EPermTypeCustViewAll  = 8,
  EPermTypeCustViewDet  = 9,
  EPermTypeCustAddNew   = 10,
  EPermTypeCustEdit     = 11,
  EPermTypeCustDelete   = 12,
  EPermTypeCatViewAll   = 13,
  EPermTypeCatViewDet   = 14,
  EPermTypeCatAddNew    = 15,
  EPermTypeCatEdit      = 16,
  EPermTypeCatDelete    = 17,
  EPermTypeAnalCustOver = 19,
  EPermTypeAnalPayOver  = 20,
  EPermTypeAnalCatOver  = 21,
  EPermTypeAnalDetailed = 22,
  EPermTypeActViewOwn   = 23,
  EPermTypeActViewAll   = 24,
  EPermTypeUsersAdd     = 25,
  EPermTypeUsersEdit    = 26,
  EPermTypeUsersDelete  = 27,
  EPermTypeUsersGrpMan  = 28,
  EPermTypeUsersPwdRes  = 29,
  EPermTypeGrpAdd       = 30,
  EPermTypeGrpEdit      = 31,
  EPermTypeGrpDelete    = 32,
  EPermTypeGrpPermMgmt  = 33,
  EPermTypeAcctEdit     = 34,
  EPermTypeAcctReadMgmt = 35,
  EPermTypeAcceMobile   = 36,
  EPermTypeAcceWeb      = 37,
  EPermTypeTransUpdate  = 38,
  EPermTypeAcctViewProfile  = 39,
  EPermTypePayExport    = 40,
  EPermTypeAcceptInvoice= 41,
  EPermTypeCustTerrMgmt = 42,
  EPermTypeCustViewTerr = 43,
  EPermTypePayOwnTrans = 44
}EPermissionsType;

#define KGlobalMessageAuthenticateReveal @"KGlobalMessageAuthenticateReveal"
#define KGlobalMessageAuthenticateBlank @"KGlobalMessageAuthenticateBlank"

#define KGlobalMessageAuthenticate @"KGlobalMessageAuthenticate"
#define KGlobalMessagePaymentCompleted @"KGlobalMessagePaymentCompleted"
#define KGlobalMessageRefundCompleted @"KGlobalMessageRefundCompleted"
#define KGlobalMessageSignoutCompleted @"KGlobalMessageSignoutCompleted"

#define KGlobalMessagePasswordConfirmationCancelled @"KGlobalMessagePasswordConfirmationCancelled"
#define KGlobalMessagePasswordConfirmationOK @"KGlobalMessagePasswordConfirmationOK"
#define KGlobalMessagePasswordConfirmationFailedAuth @"KGlobalMessagePasswordConfirmationFailedAuth"
#define KGlobalMessagePasswordConfirmationFailedOther @"KGlobalMessagePasswordConfirmationFailedOther"

#define KGlobalMessageNavigateToTakePayment @"KGlobalMessageNavigateToTakePayment"
#define KGlobalMessageReloadCustomers @"KGlobalMessageReloadCustomers"
#define KGlobalMessageCancelCustomerSearch @"KGlobalMessageCancelCustomerSearch"

#define KGlobalMessageCapturePhotoFromCamera @"KGlobalMessageCapturePhotoFromCamera"
#define KGlobalMessageAddPhotoFromGallery @"KGlobalMessageAddPhotoFromGallery"
#define KGlobalMessageRemovePhotoFromTransactionImages @"KGlobalMessageRemovePhotoFromTransactionImages"

#define KGlobalMessageSwipeCellBeginDragging @"KGlobalMessageSwipeCellBeginDragging"
#define KGlobalMessageReloadBillTableView @"KGlobalMessageReloadBillTableView"
#define KGlobalMessageReloadBillTableViewItem @"KGlobalMessageReloadBillTableViewItem"
#define KGlobalMessageReloadBillTableViewItemPopover @"KGlobalMessageReloadBillTableViewItemPopover"

#define KSyncFromServerPageSize 100

#define KMaxFailedLogins 3

#define kDefaultLocale @"en_US"
#define METERS_PER_MILE 1609.344

#define kSelectedMetricsKey @"selectedMetrics"
#define kAnalyticsPeriodUnit @"analyticsPeriodUnit"
#define kAnalyticsPeriodValue @"analyticsPeriodValue"
#define kAnalyticsPeriodFrom @"analyticsPeriodFrom"
#define kAnalyticsPeriodTo @"analyticsPeriodTo"
#define kAnalyticsPeriodType @"analyticsPeriodType"

#define kSignatureFileName @"CustomerSig.png"

#define kFRCActivityLimit 300

#endif

