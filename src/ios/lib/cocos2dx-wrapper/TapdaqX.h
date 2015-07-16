//
//  TapdaqX.h
//  Tapdaq
//  0.2.5
//
//  Created by Nick Reffitt <nick@tapdaq.com> on 21/01/2014
//  Copyright 2014 Liquid5 Ltd. All rights reserved.
//

#ifndef __TapdaqX__
#define __TapdaqX__

#include "cocos2d.h"

class TapdaqX {
public:
    static void startSession(const char* appId, const char *clientKey);
    static void showInterstitial();
};

#endif /* defined(__DTapdaqX__) */
