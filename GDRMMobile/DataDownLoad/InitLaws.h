//
//  InitLaws.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "InitData.h"

@interface InitLaws : InitData
- (void)downLoadLaws:(NSString *)orgID;
@end


@interface InitLawBreakingAction : InitData
- (void)downloadLawBreakingAction:(NSString *)orgID;
@end

@interface InitLawItems : InitData
- (void)downloadLawItems:(NSString *)orgID;
@end

@interface InitMatchLaw : InitData
- (void)downloadMatchLaw:(NSString *)orgID;
@end

@interface InitMatchLawDetails : InitData
- (void)downloadMatchLawDetails:(NSString *)orgID;
@end