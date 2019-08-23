//
//  InitUser.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitUser.h"
#import "UserInfo.h"
//#import "AFNetworking.h"
//#import "ALinNetworkTool.h"
//#import "MJExtension.h"
@implementation InitUser

- (void)downLoadUserInfo:(NSString *)orgID{
    WebServiceInit;
    //[service downloadDataSet:@"select * from UserInfo" orgid:orgID];
    [service downloadDataSet:[@"select * from UserInfo where org_id = " stringByAppendingString:orgID]];
    //Command=GetItems&sql=encodeURIComponent("select * from userinfo")
    
    /*
     NSDictionary *params=@{
     @"Command":@"GetItems",
     @"sql":@"select * from userinfo"
     };
     
     
     
     // 创建请求类
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     [manager GET:@"http://120.76.189.168/xbyh_ceshi/Framework/DataBase.ashx" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
     // 这里可以获取到目前数据请求的进度
     NSLog(@"%@",downloadProgress);
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     // 请求成功
     if(responseObject){
     NSMutableArray *dict = [NSJSONSerialization  JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
     
     //NSMutableArray *dataArray=[NSMutableArray arrayWithObject:responseObject];
     //NSArray *result = [UserInfo mj_objectArrayWithKeyValuesArray:responseObject];
     //NSMutableArray *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
     //success(dict,YES);
     NSLog(@"-------%@",[dict[0] valueForKey:@"name"]);
     
     } else {
     // success(@{@"msg":@"暂无数据"}, NO);
     }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     // 请求失败
     //fail(error);
     NSLog(@"%@",[error localizedDescription]);
     }];
     
     */
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return  [self autoParserForDataModel:@"UserInfo" andInXMLString:webString];
}

@end

@implementation InitOrgInfo

- (void)downLoadOrgInfo:(NSString *)orgID{
    WebServiceInit;
//    [service downloadDataSet:[NSString stringWithFormat:@"select * from OrgInfo where orgname like %%%@%%",@"广肇"] orgid:orgID];
    [service downloadDataSet:@"select * from OrgInfo" orgid:orgID];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"OrgInfo" andInXMLString:webString];
}
@end
