//
//  TapdaqX.mm
//  Tapdaq
//  0.2.5
//
//  Created by Nick Reffitt <nick@tapdaq.com> on 21/01/2014
//  Copyright 2014 Liquid5 Ltd. All rights reserved.
//

#import <Tapdaq/Tapdaq.h>
#include "TapdaqX.h"

void TapdaqX::startSession(const char* appId, const char* clientKey)
{
    [[Tapdaq sharedSession] setApplicationId:[NSString stringWithCString:appId encoding:NSStringEncodingConversionAllowLossy] clientKey:[NSString stringWithCString:clientKey encoding:NSStringEncodingConversionAllowLossy]];
}

void TapdaqX::showInterstitial()
{
    [[Tapdaq sharedSession] showInterstitial];
}