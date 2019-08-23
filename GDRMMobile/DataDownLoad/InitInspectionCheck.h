//
//  InitInspectionCheck.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import <Foundation/Foundation.h>
#import "InitData.h"
#import "CheckHandle.h"
#import "CheckStatus.h"
#import "CheckReason.h"
#import "CheckType.h"
#import "CheckItemDetails.h"
#import "CheckItems.h"

@interface InitCheckType :InitData
- (void)downLoadCheckType:(NSString *)orgID;
@end

@interface InitCheckReason : InitData
- (void)downLoadCheckReason:(NSString *)orgID;
@end

@interface InitCheckHandle : InitData
- (void)downLoadCheckHandle:(NSString *)orgID;
@end

@interface InitCheckStatus : InitData
- (void)downLoadCheckStatus:(NSString *)orgID;
@end

@interface InitCheckItems : InitData
- (void)downloadCheckItems:(NSString *)orgID;
@end

@interface InitCheckItemDetails : InitData
- (void)downloadCheckItemDetails:(NSString *)orgID;
@end