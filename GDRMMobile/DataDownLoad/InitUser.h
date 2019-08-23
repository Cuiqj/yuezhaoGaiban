//
//  InitUser.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InitData.h"

@interface InitUser : InitData
-(void)downLoadUserInfo:(NSString *)orgID;
@end

@interface InitOrgInfo:InitData
- (void)downLoadOrgInfo:(NSString *)orgID;
@end