//
//  SKTextureAtlas+Helper.m
//  Mole
//
//  Created by dengwei on 15/12/19.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "SKTextureAtlas+Helper.h"

@implementation SKTextureAtlas (Helper)

+(SKTextureAtlas *)atlasWithNamed:(NSString *)atlasName
{
    if (IS_IPAD) {
        atlasName = [NSString stringWithFormat:@"%@-ipad", atlasName];
        XLog(@"ipad");
    }else if (IS_IPHONE_5){
        atlasName = [NSString stringWithFormat:@"%@-568", atlasName];
        XLog(@"iphone5");
    }
    
    return [SKTextureAtlas atlasNamed:atlasName];
}

@end
