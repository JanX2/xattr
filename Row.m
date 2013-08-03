//
//  Row.m
//  xattr
//
//  Created by Robert Pointon on 15/06/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "Row.h"


@implementation Row

- (id)initWithDelegate:(id)aDelegate name:(NSString *)aName value:(NSData *)aValue
{
    if (self = [super init]) {
        delegate = aDelegate;
        name = [aName retain];
        data = [aValue retain];
    }
    return self;
}

- (NSString *)name
{
    return name;
}

- (NSData *)data
{
    return data;
}

- (NSString *)value
{
    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

- (void)setName:(NSString *)aName
{
    NSString *previous = name;
    name = [aName retain];
    [delegate nameEdit:self previousName:previous];
    [previous release];
}

- (void)setValue:(NSString *)aValue
{
    [data release];
    data = [[aValue dataUsingEncoding:NSUTF8StringEncoding] retain];
    [delegate valueEdit:self];
}

- (NSUInteger)valueSize
{
    return [data length];
}

/*
 * Lets define some nice stuff for some common keys
 */

#define XAttrFinderInfo         @"com.apple.FinderInfo"
#define XAttrResourceFork       @"com.apple.ResourceFork"
#define XAttrDiskCheckSum       @"com.apple.diskimages.recentcksum"

- (NSString *)displayName
{
    if ([name isEqual:XAttrFinderInfo]) {
        return @"Finder Info";
    }
    if ([name isEqual:XAttrResourceFork]) {
        return @"Resource Fork";
    }
    if ([name isEqual:XAttrDiskCheckSum]) {
        return @"Disk Check Sum";
    }
    return @"Misc";
}

- (NSImage *)icon
{
    NSString *app = nil;
    NSImage *icon = nil;
    if ([name isEqual:XAttrFinderInfo]) {
        app = @"Finder.App";
    }
    if ([name isEqual:XAttrResourceFork]) {
        icon = [NSImage imageNamed:@"resedit.gif"];
    }
    if ([name isEqual:XAttrDiskCheckSum]) {
        app = @"Disk Utility.App";
    }
    
    if (app && !icon) {
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        NSString *path = [ws fullPathForApplication:app];
        if (path) {
            icon = [ws iconForFile:path];
        }
    }
    if (!icon) {
        icon = [[[NSImage alloc] init] autorelease];
    }
    return icon;
}

@end
