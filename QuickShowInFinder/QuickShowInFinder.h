//
//  QuickShowInFinder.h
//  QuickShowInFinder
//
//  Created by qinzhiwei on 15/12/22.
//  Copyright © 2015年 qinzhiwei. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface QuickShowInFinder : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end