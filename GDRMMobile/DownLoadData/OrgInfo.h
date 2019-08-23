//
//  OrgInfo.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-20.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrgInfo : NSManagedObject

@property (nonatomic, retain) NSString * belongtoorg_id;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * orgname;
@property (nonatomic, retain) NSString * orgshortname;
@property (nonatomic, retain) NSString * orgtype;
@property (nonatomic, retain) NSString * orgcode;
@property (nonatomic, retain) NSString * bankaccount;
@property (nonatomic, retain) NSString * orgdesc;
@property (nonatomic, retain) NSString * principal;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * faxnumber;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSString * linkman;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * isselected;
//@property (nonatomic, retain) NSString * code;
//@property (nonatomic, retain) NSString * name;
//@property (nonatomic, retain) NSString * short_name;
//@property (nonatomic, retain) NSString * parent_id;

+ (OrgInfo *)orgInfoForOrgID:(NSString *)orgID;
+ (OrgInfo *)orgInfoForSelected;
+ (NSArray *)allOrgInfo;


+ (NSString *)orgInfoFororgshortname:(NSString *)orgID;
@end
