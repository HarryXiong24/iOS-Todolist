//
//  StoreOperation.h
//  XTodo
//

#import <Foundation/Foundation.h>
#import "TodoItem.h"

@interface StoreOperation : NSObject

- (NSMutableArray<TodoItem *> *)getTodoList;
- (NSMutableArray<TodoItem *> *)getCompletedList;

- (void)savedTodoListWithTitle:(NSString *)title content:(NSString *)content date:(NSDate *)date;
- (void)savedCompletedListWithTitle:(NSString *)title content:(NSString *)content date:(NSDate *)date;

- (void)removeItemWithNo:(int)itemNo;
- (void)removeCompletedItemWithNo:(int)itemNo;

- (void)resetTodoList;
- (void)resetCompletedList;

@end
