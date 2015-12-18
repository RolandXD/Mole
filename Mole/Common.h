//
//  Common.h
//  Mole
//
//  Created by apple on 13-12-15.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#define IS_IPAD     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_RETINA   ([[UIScreen mainScreen] scale] == 2.0f)
