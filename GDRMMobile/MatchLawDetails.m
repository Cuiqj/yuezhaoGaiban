//
//  MatchLawDetails.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "MatchLawDetails.h"
#import "MatchLaw.h"
#import "Laws.h"
#import "LawItems.h"
@implementation MatchLawDetails

@dynamic law_id;
@dynamic lawitem_id;
@dynamic matchlaw_id;
@dynamic myid;
@dynamic type;

+ (NSArray *) matchLawDetailsForMatchlawID:(NSString *)matchlawID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"matchlaw_id == %@ ",matchlawID]];
    return [context executeFetchRequest:fetchRequest error:nil];
}
+ (NSMutableDictionary *)matchLawsForLawbreakingActionID:(NSString *)lawbreakActionID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"MatchLaw" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    //[fetchRequest setPredicate:nil];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"lawbreakingaction_id == %@ ",lawbreakActionID]];
    NSArray *returnTemp = [context executeFetchRequest:fetchRequest error:nil];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    
    for (MatchLaw *matchLaw in returnTemp) {
        [temp addObjectsFromArray:[self matchLawDetailsForMatchlawID:matchLaw.myid]];
    }
    NSMutableDictionary *matchInfo = [[NSMutableDictionary alloc]init];
    NSMutableArray *breakLaws = [[NSMutableArray alloc]init];
    NSMutableArray *matchLaws = [[NSMutableArray alloc]init];
    NSMutableArray *payLaws = [[NSMutableArray alloc]init];
    for (MatchLawDetails *detail in temp) {
        Laws *law = [Laws lawsForLawID:detail.law_id];
        LawItems *lawItem = [LawItems lawItemForLawID:detail.law_id andItemNo:detail.lawitem_id];
        NSString *lawContent = [NSString stringWithFormat:@"%@%@",law.caption,lawItem.lawitem_no ];
        //break law
        if ([detail.type intValue] == 0) {
            [breakLaws addObject:lawContent];
        }else if([detail.type intValue] == 1){
            //match law
            [matchLaws addObject:lawContent];
        }
    }
    [payLaws addObject:@"广东省《损坏公路路产赔偿标准》（粤交路[1998]38号、[1999]263号）"];
    [matchInfo setObject:breakLaws forKey:@"breakLaw"];
    [matchInfo setObject:matchLaws forKey:@"matchLaw"];
    [matchInfo setObject:payLaws forKey:@"payLaw"];
    return matchInfo;
}
@end
