//
//  AFMeaning.h
//  AcronymFinder
//
//  Created by SaratS on 10/04/17.
//  Copyright © 2017 SaratS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFMeaning : NSObject

//Meaning of the Acronym
@property (nonatomic, copy) NSString *meaning;
//The number of occurrences of the definition in the corpus
@property NSInteger frequency;
//The year when the definition appeared for the first time in the corpus
@property NSInteger since;
//An array of variation objects that gather surface expressions of the full form in the corpus
@property (nonatomic, copy) NSMutableArray *variations;

/**
*
* COMMENT: For this coding exercise(as per document), meaning would suffice. Added other attributes (frequency, since, variations) just to showcase the purpose/ability of this model.
*
*/
@end
