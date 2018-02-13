//
//  TDTestDevices.h
//  Tapdaq iOS SDK
//
//  Created by Nick Reffitt on 08/01/2017.
//  Copyright © 2017 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMNetworkEnum.h"

@interface TDTestDevices : NSObject

@property (nonatomic) TDMNetwork network;
@property (nonatomic, strong) NSArray *testDevices;

- (id)initWithNetwork:(TDMNetwork)network testDevices:(NSArray *)testDevices;

@end
