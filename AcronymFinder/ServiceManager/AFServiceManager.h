//
//  AFServiceManager.h
//  AcronymFinder
//
//  Created by SaratS on 10/04/17.
//  Copyright © 2017 SaratS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFAcronym.h"
#import "AFMeaning.h"

typedef void (^GetMeaningsSuccessBlock)(AFAcronym *acronym);
typedef void (^GetMeaningsFailureBlock)(NSError *error);

@interface AFServiceManager : NSObject

/*
 * @discussion This methofs returns shared manager for AFServices
 * @return SingleTon instance of AFServiceManager
 */
+ (instancetype)sharedManager;

/*
 * @discussion - This method fetches all the meanings fot the queries Acronym.
 * @param acronym acronym string
 * @param success Successblock to be called on service success
 * @prama failure FailureBlock to be called on service failure
 */
- (void)getMeaningsForAcronym:(NSString *)acronym success:(GetMeaningsSuccessBlock) success failure:(GetMeaningsFailureBlock) failure;

@end
