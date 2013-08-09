//
//  Row.h
//  xattr
//
//  Created by Robert Pointon on 15/06/2005.
//
//  Copyright 2005 Robert Pointon. Do whatever you want. I make no claim that it’s correct or bug free.
//  Copyright 2013 Jan Weiß. Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

#import <Cocoa/Cocoa.h>


@interface Row : NSObject {
	NSString *name;
	NSData *data;
	id delegate;
}

// Weak linking of delegate
- (id)initWithDelegate:(id)aDelegate name:(NSString *)aName value:(NSData *)aValue;

- (NSString *)name;
- (NSData *)data;

// some extras to make things look nice
- (NSString *)displayName;
- (NSImage *)icon;
- (NSUInteger)valueSize;

- (NSString *)value; //string from data

- (void)setName:(NSString *)aName;
- (void)setValue:(NSString *)aValue;


@end

@interface NSObject (RowDelegate)
- (void)nameEdit:(Row *)row previousName:(NSString *)previous;
- (void)valueEdit:(Row *)row;
@end
