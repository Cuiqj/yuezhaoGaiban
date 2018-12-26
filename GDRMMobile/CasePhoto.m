//
//  CasePhoto.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-27.
//
//

#import "CasePhoto.h"


@implementation CasePhoto

@dynamic photo_name;
@dynamic isuploaded;
@dynamic proveinfo_id;
@dynamic myid;
@dynamic remark;
@dynamic project_id;
@dynamic type_desc;
- (NSString *) signStr{
    if (![self.proveinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"proveinfo_id == %@", self.proveinfo_id];
    }else{
        return @"";
    }
}
+(NSArray *)casePhotosForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CasePhoto" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"project_id == %@",caseID];
    fetchRequest.predicate=predicate;
    return [context executeFetchRequest:fetchRequest error:nil];
}
+(NSArray *)casePhotos:(NSString *)proveinfoId{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CasePhoto" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id == %@",proveinfoId];
    fetchRequest.predicate=predicate;
    return [context executeFetchRequest:fetchRequest error:nil];
}

+(CasePhoto *)casePhotoById:(NSString *)myId{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CasePhoto" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid == %@",myId];
    fetchRequest.predicate=predicate;
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    if([array count] > 0)
    {
        return [[context executeFetchRequest:fetchRequest error:nil]objectAtIndex:0];
    }
    return nil;
}
+ (void)deletePhotoForCase:(NSString *)caseID photoName:(NSString *)photoName{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CasePhoto" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"project_id == %@ && photo_name == %@",caseID,photoName];
    fetchRequest.predicate=predicate;
    NSArray *temp = [context executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *obj in temp) {
        [context deleteObject:obj];
    }
    [[AppDelegate App] saveContext];
}
+ (void)deletePhotoForProveInfo:(NSString *)proveinfo_id photoName:(NSString *)photoName{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CasePhoto" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id == %@ && photo_name == %@",proveinfo_id,photoName];
    fetchRequest.predicate=predicate;
    NSArray *temp = [context executeFetchRequest:fetchRequest error:nil];
    
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath=[pathArray objectAtIndex:0];
    NSString *photoPath=[NSString stringWithFormat:@"InspectionConstruction/%@",proveinfo_id];
    photoPath=[documentPath stringByAppendingPathComponent:photoPath];
    
    for (NSManagedObject *obj in temp) {
        CasePhoto *casePhoto = (CasePhoto *)obj;
        [[NSFileManager defaultManager]removeItemAtPath:[photoPath stringByAppendingPathComponent:casePhoto.photo_name] error:nil];
        [context deleteObject:obj];
    }
    [[AppDelegate App] saveContext];
    
}
@end
