//
//  RoadSegment.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-14.
//
//

#import "RoadSegment.h"


@implementation RoadSegment


@dynamic code;
@dynamic delflag;
@dynamic driveway_count;
@dynamic group_flag;
@dynamic group_id;
@dynamic name;
@dynamic organization_id;
@dynamic place_end;
@dynamic place_start;
@dynamic place_prefix1;
@dynamic place_prefix2;
@dynamic road_grade;
@dynamic road_id;
@dynamic myid;
@dynamic station_end;
@dynamic station_start;

//根据路段ID返回路段名称
+ (NSString *)roadNameFromSegment:(NSString *)segmentID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid == %@",segmentID]];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    if (temp.count>0) {
        id obj=[temp objectAtIndex:0];
        //return [obj name];
        return [obj valueForKey:@"place_prefix1"];
    } else {
        return @"";
    }
}

//返回所有的路段名称和路段号
+ (NSArray *)allRoadSegments{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    return [context executeFetchRequest:fetchRequest error:nil];
}
+ (NSArray *)allRoadSegmentsForCaseView{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    NSArray *temple=  [context executeFetchRequest:fetchRequest error:nil];
    //    RoadSegment *data= [[RoadSegment alloc] init];
//    data.name=@"收费站";
//    data.myid=@"666666666";
    id data = @{
                @"name":@"收费站",
                @"myid":@"0",
                @"place_prefix1":@"收费站"
                };
//    [data setName:@"收费站" ];
//    [data setMyid:@"666666666" ];
    NSMutableArray  *results= [[NSMutableArray alloc] initWithArray:temple];
//    for(int i=0;i<temple.count;i++){
//        id data  ;
//        [data setValue:[temple[i] valueForKey:@"myid"] forKey:@"myid"];
//        [data setValue:[temple[i] valueForKey:@"name"] forKey:@"name"];
//        [ results addObject:data];
//    }
    if(data != nil)
        [results addObject:data];
    //return temple;
    return results;
}
@end
