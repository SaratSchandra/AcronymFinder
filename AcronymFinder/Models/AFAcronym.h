//
//  AFAcronym.h
//  AcronymFinder
//
//  Created by SaratS on 10/04/17.
//  Copyright © 2017 SaratS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFAcronym : NSObject

//Short form for the Acronym
@property (nonatomic,copy) NSString *shortForm;
//Meanings for the Acronym
@property (nonatomic,copy) NSMutableArray *meanings;

@end
