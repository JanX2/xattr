//
//  App.h
//  xattr
//
//  Created by Robert Pointon on 14/06/2005.
//
//  Copyright 2005 Robert Pointon. Do whatever you want. I make no claim that it’s correct or bug free.
//  Copyright 2013 Jan Weiß. Some rights reserved: <http://opensource.org/licenses/mit-license.php>
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
