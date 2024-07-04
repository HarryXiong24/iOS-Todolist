//
//  TodoItem.m
//  XTodo
//

#import <Foundation/Foundation.h>

@interface TodoItem : NSObject

@property (nonatomic, readwrite) int no;
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *content;
@property (nonatomic, readwrite) NSDate *date;

- (instancetype)initWithNo:(int)no title:(NSString *)title content:(NSString *)content date:(NSDate *)date;

@end

