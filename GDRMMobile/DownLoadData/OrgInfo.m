//
//  OrgInfo.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-20.
//
//

#import "OrgInfo.h"


@implementation OrgInfo

@dynamic belongtoorg_id;
@dynamic myid;
@dynamic orgname;
@dynamic orgshortname;
@dynamic orgtype;
@dynamic orgcode;
@dynamic bankaccount;
@dynamic orgdesc;
@dynamic principal;
@dynamic address;
@dynamic faxnumber;
@dynamic level;
@dynamic linkman;
@dynamic postcode;
@dynamic telephone;
@dynamic remark;
@dynamic isselected;
//@dynamic code;
//@dynamic name;
//@dynamic short_name;
//@dynamic parent_id;

+ (OrgInfo *)orgInfoForOrgID:(NSString *)orgID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid == %@",orgID]];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    if (temp.count>0) {
        return [temp lastObject];
    } else {
        return nil;
    }
}
+ (OrgInfo *)orgInfoForSelected{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSString *currentOrgID=[[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid ==%@",currentOrgID]];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    if (temp.count>0) {
        return [temp lastObject];
    } else {
        return nil;
    }
}
+ (NSArray *)allOrgInfo{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (NSString *)orgInfoFororgshortname:(NSString *)orgID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid == %@",orgID]];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    if (temp.count>0) {
        id obj=[temp objectAtIndex:0];
        //return [obj name];
        return [obj valueForKey:@"orgshortname"];
    } else {
        return @"";
    }
}


@end
