//
//  Citizen.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-19.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface Citizen : BaseManageObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * automobile_address;
@property (nonatomic, retain) NSString * automobile_number;
@property (nonatomic, retain) NSString * automobile_owner;
@property (nonatomic, retain) NSString * automobile_pattern;
@property (nonatomic, retain) NSString * bad_desc;
@property (nonatomic, retain) NSString * card_name;
@property (nonatomic, retain) NSString * card_no;
@property (nonatomic, retain) NSString * carowner;
@property (nonatomic, retain) NSString * carowner_address;
@property (nonatomic, retain) NSString * proveinfo_id;
@property (nonatomic, retain) NSNumber * compensate_money;
@property (nonatomic, retain) NSString * driver;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSString * nationality;
@property (nonatomic, retain) NSString * nexus;
@property (nonatomic, retain) NSString * org_name;
@property (nonatomic, retain) NSString * org_full_name;
@property (nonatomic, retain) NSString * org_principal;
@property (nonatomic, retain) NSString * org_principal_duty;
@property (nonatomic, retain) NSString * org_principal_tel_number;
@property (nonatomic, retain) NSString * org_tel_number;
@property (nonatomic, retain) NSString * original_home;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSString * patry_type;
@property (nonatomic, retain) NSString * postalcode;
@property (nonatomic, retain) NSString * profession;
@property (nonatomic, retain) NSNumber * proportion;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * tel_number;


+ (NSArray *)allCitizenNameForCase:(NSString *)caseID;
+ (Citizen *)citizenForName:(NSString *)autoNumber nexus:(NSString *)nexus case:(NSString *)caseID;
+ (Citizen *)citizenForParty:(NSString *)party case:(NSString *)caseID;

//add by lxm 2013.05.13
+ (Citizen *)citizenForCitizenName:(NSString *)name nexus:(NSString *)nexus case:(NSString *)caseID;



#pragma mark - 行政处罚  需要注意的是跟【路政案件】的最大区别是 对应一个案件，一个类别(当事人,组织代表等)只有一个对应的当事人，不会有多个，也就说，相对于路政案件，不会有多车辆问题
+ (Citizen *)citizenByCaseID:(NSString *)caseID andNexus:(NSString *)nexus;
+ (Citizen *)citizenByCaseID:(NSString *)caseID;
@end
