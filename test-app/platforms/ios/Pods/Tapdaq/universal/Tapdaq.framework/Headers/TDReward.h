//
//  TDReward.h
//  Tapdaq
//
//  Created by Dmitry Dovgoshliubnyi on 30/11/2017.
//  Copyright © 2017 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TDRewardModel;

@interface TDReward : NSObject
@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) int value;
@property (strong, nonatomic) NSString *tag;
@property (strong, nonatomic) id customJson;
@end
