//
//  NSString+Base64.h
//  GDRMMobile
//
//  Created by maijunjin on 14-11-20.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)
+ (NSString*)base64forData:(NSData*)theData;
@end
