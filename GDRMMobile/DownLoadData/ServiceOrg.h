//
//  ServiceOrg.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/5/3.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ServiceOrg : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * fuzeren;
@property (nonatomic, retain) NSString * linktel;
+(NSArray *) allServiceOrg;
+(NSString *) allServiceOrg_NameIDforname:(NSString *)name;
+(NSString *)ServiceOrgNameforServiceNameID:(NSString *)servicename;
@end
