//
//  CasePhoto.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface CasePhoto : BaseManageObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * proveinfo_id;
@property (nonatomic, retain) NSNumber * type_desc;
@property (nonatomic, retain) NSString * photo_name;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * isuploaded;
+(NSArray *)casePhotosForCase:(NSString *)caseID;
+ (void)deletePhotoForCase:(NSString *)caseID photoName:(NSString *)photoName;
+(NSArray *)casePhotos:(NSString *)proveinfoId;
+(CasePhoto *)casePhotoById:(NSString *)myId;
@end
