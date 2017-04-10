//
//  AFServiceManager.m
//  AcronymFinder
//
//  Created by SaratS on 10/04/17.
//  Copyright © 2017 SaratS. All rights reserved.
//

#import "AFServiceManager.h"
#import "AFNetworking.h"
#import "AFConstants.h"

@implementation AFServiceManager

+(instancetype) sharedManager {
    static AFServiceManager *sharedManager = nil;
    static dispatch_once_t once ;
    dispatch_once(&once, ^{
        sharedManager = [[AFServiceManager alloc] init];
    });
    return sharedManager;
}

- (void)getMeaningsForAcronym:(NSString *)acronym success:(GetMeaningsSuccessBlock) success failure:(GetMeaningsFailureBlock) failure{
    
    NSDictionary *parameters = @{@"sf": acronym};
    NSURL *baseURL = [NSURL URLWithString:AFBaseURL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager GET:@"" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

        success([self parseResponseObject:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
}

#pragma mark-  Object mapper methods

/*
 * Below are helper methods for getting the Mapped - Model objects.
 *
 *
 * In real time applications, where we work with large number of services and different processing logics, we write more generic Object mapper or Adapter Classes. So, that those Mapper/Adapters can be made scalable based on our needs.
 *
 *
 */

-(AFAcronym *) parseResponseObject:(id) responseObject {
    
    if([responseObject isKindOfClass:[NSArray class]] && [responseObject count] > 0 ){
        NSDictionary *dict = [responseObject firstObject]; //Though we have an array here, we go for first object in the array, which has the details of acronym meanings
        AFAcronym *acronym = [[AFAcronym alloc] init];
        [acronym setShortForm: [dict objectForKey:@"sf"]] ;
        [acronym setMeanings:[self getMeanings:[dict objectForKey:@"lfs"]]];
        return acronym;
    }
    return nil;
}
-(NSMutableArray *) getMeanings:(NSMutableArray *) responseArray {
    NSMutableArray *meaningArray = [NSMutableArray array];
    for(NSDictionary *dict in responseArray){
        
        AFMeaning *meaning = [[AFMeaning alloc] init];
        [meaning setMeaning: [dict objectForKey:@"lf"]] ;
        [meaning setFrequency: [[dict objectForKey:@"freq"] integerValue]] ;
        [meaning setSince: [[dict objectForKey:@"since"] integerValue]] ;
        [meaning setVariations:[self getVariations:[dict objectForKey:@"vars"]]];
        [meaningArray addObject:meaning];
    }
    return meaningArray;
}

-(NSMutableArray *) getVariations:(NSMutableArray *) responseArray {
    NSMutableArray *variationsArray = [NSMutableArray array];
    for(NSDictionary *dict in responseArray){
        
        AFMeaning *meaning = [[AFMeaning alloc] init];
        [meaning setMeaning: [dict objectForKey:@"lf"]] ;
        [meaning setFrequency: [[dict objectForKey:@"freq"] integerValue]] ;
        [meaning setSince: [[dict objectForKey:@"since"] integerValue]] ;
        
        [variationsArray addObject:meaning];
    }
    return variationsArray;
}

@end
