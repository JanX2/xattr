//
//  App.h
//  xattr
//
//  Created by Robert Pointon on 14/06/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Row.h"

@interface App : NSObject {
	NSMutableArray *array;
	NSString *path;
    
	NSTableView *table;
	NSArrayController *ctrl;
}

- (NSString *)path;
- (NSArray *)array;

- (IBAction)open:(id)sender;
- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
@end
