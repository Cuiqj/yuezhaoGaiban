//
//  Systype.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-10.
//
//

#import "Systype.h"


@implementation Systype

@dynamic sys_code;
@dynamic code_name;
@dynamic type_value;
@dynamic type_code;
@dynamic remark;

+ (NSArray *)typeValueForCodeName:(NSString *)codeName{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code_name == %@",codeName]];
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
    [tempArray sortUsingDescriptors:@[sort]];
    tempArray=[[tempArray valueForKeyPath:@"type_value"] mutableCopy];
    [tempArray removeObject:[NSNull null]];
    [tempArray removeObject:@""];
    return [NSArray arrayWithArray:tempArray];
}
+ (NSArray *)sysTypeArrayForCodeName:(NSString *)codeName{

//    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
//    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
//    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
//    [fetchRequest setEntity:entity];
//    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code_name == %@",codeName]];
//    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
//    if (temp.count>0) {
//        return temp ;
//    } else {
//        return nil;
//    }
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code_name == %@",codeName]];
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
    tempArray=[[tempArray valueForKeyPath:@"type_value"] mutableCopy];
    [tempArray removeObject:[NSNull null]];
    [tempArray removeObject:@""];
    return [NSArray arrayWithArray:tempArray];
}
+ (NSString *)sysTypeForCodeNameAndTypeValue:(NSString *)codeName withType_value:(NSString *)type_value{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(code_name == %@) && (type_value==%@)",codeName,type_value]];
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
    [tempArray sortUsingDescriptors:@[sort]];
    tempArray=[[tempArray valueForKeyPath:@"remark"] mutableCopy];
    [tempArray removeObject:[NSNull null]];
    [tempArray removeObject:@""];
    if(tempArray.count>0)
   // return [[[NSArray arrayWithArray:tempArray] lastObject] valueForKey:@"type_value"];
        return [[NSArray arrayWithArray:tempArray] lastObject] ;
    else
        return nil;
}
+ (NSString *)typeValueForCodeName:(NSString *)codeName andSys_code:(NSString*)sys_code{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code_name == %@ && sys_code==%@",codeName,sys_code]];
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
    [tempArray sortUsingDescriptors:@[sort]];
    tempArray=[[tempArray valueForKeyPath:@"type_value"] mutableCopy];
    [tempArray removeObject:[NSNull null]];
    [tempArray removeObject:@""];
    return [tempArray firstObject];
}


@end
