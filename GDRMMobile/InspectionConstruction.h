//
//  InspectionConstruction.h
//  GDRMMobile
//
//  Created by yu hongwu on 14-8-18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface InspectionConstruction : BaseManageObject

@property (nonatomic, retain) NSDate * inspectiondate;
@property (nonatomic, retain) NSDate * timestart1;
@property (nonatomic, retain) NSDate * timeend1;
@property (nonatomic, retain) NSDate * timeend2;
@property (nonatomic, retain) NSString * weather1;
@property (nonatomic, retain) NSNumber * stationstart1;
@property (nonatomic, retain) NSNumber * stationend1;
@property (nonatomic, retain) NSString * inspectionor1;
@property (nonatomic, retain) NSDate * timestart2;
@property (nonatomic, retain) NSString * weather2;
@property (nonatomic, retain) NSNumber * stationstart2;
@property (nonatomic, retain) NSNumber * stationend2;
@property (nonatomic, retain) NSString * inspectionor2;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSNumber * isuploaded;
+ (NSArray *)inspectionConstructionInfoForID:(NSString *)inspectionConstructionID;
@end
