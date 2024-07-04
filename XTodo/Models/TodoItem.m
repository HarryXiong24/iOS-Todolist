//
//  TodoItem.m
//  XTodo
//

#import "TodoItem.h"

@interface TodoItem () <NSSecureCoding>

@end

@implementation TodoItem

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithNo:(int)no title:(NSString *)title content:(NSString *)content date:(NSDate *)date {
    self = [super init];
    
    if (self) {
        self.no = no;
        self.title = title;
        self.content = content;
        self.date = date;
    }
    
    return self;
}

// Encoding method
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.no forKey:@"no"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.date forKey:@"date"];
}

// Decoding method
- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    if (self) {
        self.no = [decoder decodeIntForKey:@"no"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.date = [decoder decodeObjectForKey:@"date"];
    }
    
    return self;
}

@end

