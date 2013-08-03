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

static NSString * convertPlistDataToXMLString(NSData *inData) {
    NSError *error;
	NSPropertyListFormat format;
    id plist =
	[NSPropertyListSerialization propertyListWithData:inData
											  options:0
											   format:&format
												error:&error];
    if (plist == nil) {
        NSLog (@"Error parsing plist: %@", error);
        return nil;
    }

	return convertPlistRootToXML(plist);
}

// Adapted from http://blog.bignerdranch.com/603-property-list-seralization/
static NSString * convertPlistRootToXML(id plist) {
    if (![NSPropertyListSerialization propertyList:plist
								  isValidForFormat:kCFPropertyListXMLFormat_v1_0]) {
        NSLog(@"Can't convert plist to XML");
        return nil;
    }
	
    NSError *error;
    NSData *data =
	[NSPropertyListSerialization dataWithPropertyList:plist
											   format:kCFPropertyListXMLFormat_v1_0
											  options:0
												error:&error];
    if (data == nil) {
        NSLog (@"Error serializing plist to xml: %@", error);
        return nil;
    }
	
	NSString *xmlString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if (xmlString == nil) {
        NSLog (@"Error converting data to string: %@", error);
        return nil;
    }
	
	return xmlString;
}

// Adapted from http://stackoverflow.com/a/4771038
static BOOL startsWith(const char *pre, const char *str)
{
    size_t lenpre = strlen(pre),
	lenstr = strlen(str);
    return (lenstr < lenpre) ? false : (strncmp(pre, str, lenpre) == 0);
}

- (NSString *)value
{
	NSString *value = nil;
	
	const char *dataBytes = (const char *)[data bytes];
	
	if (startsWith("bplist", dataBytes)) {
		id unarchivedRoot = [NSUnarchiver unarchiveObjectWithData:data];
		if (unarchivedRoot != nil) {
			value = [unarchivedRoot description];
		}
		else {
			value = convertPlistDataToXMLString(data);
		}
	} else {
		value = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	}
	
	if (value == nil) {
		// Fallback
		value = [[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding] autorelease];
	}
	
	return value;
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
