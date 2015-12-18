//
//  SKTextureAtlas+Helper.h
//  Mole
//
//  Created by dengwei on 15/12/19.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKTextureAtlas (Helper)

/**
 *  根据给定的纹理集名称自动加载不同设备需要的纹理集
 *
 *  @param atlasName 纹理集名称，不需要扩展标识
 *
 *  @return 纹理集
 */
+(SKTextureAtlas *)atlasWithNamed:(NSString *)atlasName;

@end
