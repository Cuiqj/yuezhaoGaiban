//
//  UserInfo.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-14.
//
//

#import "UserInfo.h"
#import "OrgInfo.h"


@implementation UserInfo

@dynamic account;
@dynamic address;
@dynamic cardid;
@dynamic duty;
@dynamic exelawid;
@dynamic myid;
@dynamic organization_id;
@dynamic password;
@dynamic sex;
@dynamic telephone;
@dynamic title;
@dynamic username;

+ (UserInfo *)userInfoForUserID:(NSString *)userID {
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid == %@",userID]];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    if (temp.count>0) {
        return [temp lastObject];
    } else {
        return nil;
    }
}

+ (NSArray *)allUserInfo{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"account != 'Admin'"]];
    NSLog(@"1111111context:%@",context);
    NSLog(@"222222%@",[context executeFetchRequest:fetchRequest error:nil]);
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (NSString *)orgAndDutyForUserName:(NSString *)username{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"username == %@",username]];
    id info = [[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0];
    NSString *duty = [info duty]?[info duty]:@"";
    OrgInfo *org = [OrgInfo orgInfoForOrgID:[info organization_id]];
    NSString *orgName = [org orgname]?[org orgname]:@"";
    return [NSString stringWithFormat:@"%@%@",orgName,duty];
}
+ (NSString *)exelawIDForUserName:(NSString *)username{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"username == %@",username]];
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    if (results.count == 0) {
        return @"";
    }
    id info = [[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0];
    NSString *exelawid = [info exelawid]?[info exelawid]:@"";
    return [NSString stringWithFormat:@"%@",exelawid];
}
@end
