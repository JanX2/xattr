//
//  App.m
//  xattr
//
//  Created by Robert Pointon on 14/06/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "App.h"
#import "XAttr.h"

@implementation App

/*
 * Binding control stuff
 */
 
- (NSArray*)array {
	return array;
}

- (NSString *)path {
	return path;
}

- (void)setPath:(NSString*)aPath {
	[path release];
	[self willChangeValueForKey:@"path"];
	path = [aPath retain];
	[self didChangeValueForKey:@"path"];
}

- (void)setArray:(NSMutableArray*)aArray {
	[array release];
	[self willChangeValueForKey:@"array"];
	array = [aArray retain];
	[self didChangeValueForKey:@"array"];
}

/*
 * Intermediate wrappers arround XAttr
 */
 
- (void)storeSet:(Row *)row {
	NSLog(@"set %@=%@", [row name], [row value]);
	XAttr * x = [[XAttr alloc] initWithFilePath:path];
	[x setData:[row data] forKey:[row name]];
	[x release];
}

- (void)storeClear:(NSString *)name {
	NSLog(@"delete %@", name);
	XAttr * x = [[XAttr alloc] initWithFilePath:path];
	[x removeDataForKey:name];
	[x release];
}

- (void)storeLoad {
	NSLog(@"load");
	NSMutableArray * info = [[NSMutableArray alloc] init];
	XAttr * x = [[XAttr alloc] initWithFilePath:path];
	NSArray * keys = [x keys];
	NSEnumerator *	kenum = [keys objectEnumerator];
	NSString * key;
	while((key = [kenum nextObject])) {
		Row * row = [[Row alloc] initWithDelegate:self name:key value:[x dataForKey:key]];
		[info addObject:row];
		[row release]; //now owned by info
	}
	[x release];
	[self setArray:info];
}

/*
 * Model/View stuff for the GUI
 */
 
- (IBAction)open:(id)sender {
	NSOpenPanel * sheet = [NSOpenPanel openPanel];
	[sheet setCanChooseDirectories:YES];
	[sheet beginSheetModalForWindow:nil
				  completionHandler:^(NSInteger returnCode) {
					  if(returnCode == NSOKButton) {
						  [self setPath:[(NSURL *)[[sheet URLs] objectAtIndex: 0] path]];
						  [self storeLoad];
					  }
				  }];
}

- (IBAction)add:(id)sender {
	if([path isEqual:@""]) return;
	
	NSString * key = @"new"; //+1,2,3  - @TODO need to make it unique...
	Row * row = [[Row alloc] initWithDelegate:self name:key value:[NSData data]];
	[self storeSet:row];
	[ctrl addObject:row];
	[row release]; //now owned by array	
}

- (IBAction)remove:(id)sender {
	Row * row = [[ctrl selectedObjects] objectAtIndex:0];
	[self storeClear:[row name]];	
	[ctrl remove:row];
}

//called from Row in response to a name change
- (void)nameEdit:(Row*)row previousName:(NSString*)previous {
	//delete the old row AND anything that has the same name as the new
	NSEnumerator * cenum = [[ctrl arrangedObjects] objectEnumerator];
	Row * scan;
	while((scan = [cenum nextObject])) {
		if(scan==row) {
			[self storeClear:previous];
		} else if([[scan name] isEqual:[row name]]) {
			//dont need to storeClear as we immediatly follow it with a storeSet on the same key
			[ctrl remove:scan];
		}
	}
	[self storeSet:row];
}

//called from Row in response to a value change
- (void)valueEdit:(Row*)row {
	[self storeSet:row];
}

- (void)awakeFromNib {
	path = nil;
	array = nil;
	[self setPath:@""];
	[self setArray:[[NSMutableArray alloc] init]];

/*
	XAttr * x = [[XAttr alloc] initWithFilePath:@"/Users/rpointon/Demox.html"];	
	NSArray * keys = [x keys];
	NSLog(@"all keys = %@", keys);
	
	NSEnumerator *	kenum = [keys objectEnumerator];
	NSString * name;
	while((name = [kenum nextObject])) {
		NSString * value = [[NSString alloc] initWithData:[x dataForKey:name] encoding:NSASCIIStringEncoding];
		NSLog(@"%@ = %@", name, value);
	}
	[x release];
*/	
}

@end
