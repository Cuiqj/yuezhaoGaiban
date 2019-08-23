//
//  Table101.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 16/12/20.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Table101 : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSString * road_segment;
@property (nonatomic, retain) NSNumber * station_end;
@property (nonatomic, retain) NSNumber * station_start;
@property (nonatomic,retain) NSString * stake_mark;
+ (NSArray *)allBridge;
+ (NSArray *)bridgeNameForId:(NSString *)bridge_id;
@end
