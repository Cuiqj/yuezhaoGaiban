//
//  InitShoufz.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/3/10.
//
//
#import <Foundation/Foundation.h>
#import "InitData.h"


@interface InitSfz : InitData
-(void)downLoadSfz:(NSString *)orgID;
@end

@interface InitZd:InitData
- (void)downLoadZd:(NSString *)orgID;
@end
