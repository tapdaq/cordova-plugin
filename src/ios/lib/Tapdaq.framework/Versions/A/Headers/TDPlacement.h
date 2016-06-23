//
//  TDAdTypePlacement.h
//  Tapdaq
//
//  Created by Tapdaq <support@tapdaq.com>
//  Copyright (c) 2016 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDAdTypeEnum.h"

@interface TDPlacement : NSObject

@property (nonatomic) TDAdTypes adTypes;

@property (nonatomic, strong) NSString *tag;

- (instancetype)initWithAdTypes:(TDAdTypes)adTypes forTag:(NSString *)tag;

@end
