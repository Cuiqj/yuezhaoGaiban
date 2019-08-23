//
//  Table101.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 16/12/20.
//
//

#import "Table101.h"


@implementation Table101

@dynamic myid;
@dynamic name;
@dynamic org_id;
@dynamic road_segment;
@dynamic station_end;
@dynamic station_start;
+ (NSArray *)allBridge{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"org_id == %@",codeName]];
    NSMutableArray *tempArray=[[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"type_code" ascending:YES comparator:^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    //[tempArray sortUsingDescriptors:@[sort]];
    //tempArray=[[tempArray valueForKeyPath:@"type_value"] mutableCopy];
    [tempArray removeObject:[NSNull null]];
    [tempArray removeObject:@""];
    return [NSArray arrayWithArray:tempArray];
}
+ (NSArray *)bridgeNameForId:(NSString *)bridge_id{
    
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid == %@",bridge_id]];
    NSMutableArray *tempArray=[[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"type_code" ascending:YES comparator:^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    //[tempArray sortUsingDescriptors:@[sort]];
    //tempArray=[[tempArray valueForKeyPath:@"remark"] mutableCopy];
    [tempArray removeObject:[NSNull null]];
    [tempArray removeObject:@""];
    return [NSArray arrayWithArray:tempArray];
}


@end
