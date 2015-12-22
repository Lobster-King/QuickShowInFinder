//
//  QuickShowInFinder.m
//  QuickShowInFinder
//
//  Created by qinzhiwei on 15/12/22.
//  Copyright © 2015年 qinzhiwei. All rights reserved.
//

#import "QuickShowInFinder.h"

static QuickShowInFinder *sharedPlugin;

@interface QuickShowInFinder()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, copy) NSString *url;
@end

@implementation QuickShowInFinder

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        
        // Add notification.
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:nil object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didApplicationFinishLaunchingNotification:)                                                   name:NSApplicationDidFinishLaunchingNotification object:nil];
    }
    return self;
}

// handle notificaiton
- (void)handleNotification:(NSNotification *)notificaiton{
    if ([notificaiton.name isEqualToString:@"transition from one file to another"]) {
        NSURL *fileUrl = [[notificaiton.object valueForKey:@"next"] valueForKey:@"documentURL"];
        if (fileUrl != nil && [fileUrl absoluteString].length >= 7) {
            self.url = [fileUrl.absoluteString substringFromIndex:7];
        }
    }
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Do Action" action:@selector(doMenuAction) keyEquivalent:@"O"];
        [actionMenuItem setKeyEquivalentModifierMask:NSShiftKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

// Sample Action, for menu item:
- (void)doMenuAction
{
    //go to file
    [[NSWorkspace sharedWorkspace] selectFile:self.url inFileViewerRootedAtPath:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
