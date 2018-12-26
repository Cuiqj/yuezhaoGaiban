//
//  CaseDocuments.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-8.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "CaseDocuments.h"


@implementation CaseDocuments

@dynamic caseinfo_id;
@dynamic document_name;
@dynamic document_path;

+ (void)deleteDocumentsForCase:(NSString *)caseID docName:(NSString *)docName{
    if (docName && ![docName isEmpty]) {
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseDocuments" inManagedObjectContext:context];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@ && document_name == %@",caseID,docName];
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        NSArray *temp = [context executeFetchRequest:fetchRequest error:nil];
        for (CaseDocuments *doc in temp) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:doc.document_path]){
                [[NSFileManager defaultManager] removeItemAtPath:doc.document_path error:nil];
            }
            [context deleteObject:doc];
            [[AppDelegate App] saveContext];
        }
    }
}

+ (NSArray *)caseDocumentsForCase:(NSString *)caseID docName:(NSString *)docName{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseDocuments" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@ && document_name == %@",caseID,docName];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (BOOL)isExistingDocumentForCase:(NSString *)caseID docPath:(NSString *)docPath{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseDocuments" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@ && document_path == %@",caseID,docPath];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSInteger count = [context countForFetchRequest:fetchRequest error:nil];
    if (count > 0) {
        return YES;
    } else {
        return NO;
    }
}
@end
