//
//  Systype.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-10.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Systype : NSManagedObject

@property (nonatomic, retain) NSString * sys_code;
@property (nonatomic, retain) NSString * code_name;
@property (nonatomic, retain) NSString * type_value;
@property (nonatomic, retain) NSString * type_code;
@property (nonatomic, retain) NSString * remark;

+ (NSArray *)typeValueForCodeName:(NSString *)codeName;
+ (NSArray *)sysTypeArrayForCodeName:(NSString *)codeName;
+ (NSString *)sysTypeForCodeNameAndTypeValue:(NSString *)codeName withType_value:(NSString *)type_value;
+ (NSString *)typeValueForCodeName:(NSString *)codeName andSys_code:(NSString*)sys_code;
@end
