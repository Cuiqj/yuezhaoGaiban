//
//  ServiceOrg.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/5/3.
//
//

#import "ServiceOrg.h"


@implementation ServiceOrg

@dynamic myid;
@dynamic name;
@dynamic fuzeren;
@dynamic linktel;
+(NSArray *) allServiceOrg{
    NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ServiceOrg" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        return nil;
    }
    return fetchedObjects;
}


+(NSString *) allServiceOrg_NameIDforname:(NSString *)name{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"ServiceOrg" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name==%@",name];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        id obj=[fetchResult objectAtIndex:0];
        return [obj valueForKey:@"myid"];
    } else {
        return nil;
    }
}
+(NSString *)ServiceOrgNameforServiceNameID:(NSString *)servicename{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"ServiceOrg" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid==%@",servicename];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        id obj=[fetchResult objectAtIndex:0];
        return [obj valueForKey:@"name"];
    } else {
        return nil;
    }
}
@end
