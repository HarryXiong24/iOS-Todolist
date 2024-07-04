//
//  StoreOperation.m
//  XTodo
//

#import "StoreOperation.h"

@interface StoreOperation ()

@property (nonatomic, strong, readwrite) NSUserDefaults *defaults;
@property (nonatomic, strong, readwrite) NSData *savedData;
@property (nonatomic, strong, readwrite) NSData *completedData;

@end

@implementation StoreOperation

- (instancetype)init {
    self = [super init];

    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }

    return self;
}

- (NSMutableArray<TodoItem *> *)getTodoList {
    self.savedData = [self.defaults objectForKey:@"todoItems"];
    NSMutableArray<TodoItem *> *todoList = [NSMutableArray array];

    if (self.savedData) {
        NSError *error;
        NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [TodoItem class], [NSString class], [NSDate class], nil];
        todoList = (NSMutableArray<TodoItem *> *)[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:self.savedData error:&error];

        if (error) {
            NSLog(@"Failed to unarchive todo items: %@", error);
        }
    }
    
    return todoList;
}

- (NSMutableArray<TodoItem *> *)getCompletedList {
    self.completedData = [self.defaults objectForKey:@"completedItems"];
    NSMutableArray<TodoItem *> *completedList = [NSMutableArray array];

    if (self.completedData) {
        NSError *error;
        NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [TodoItem class], [NSString class], [NSDate class], nil];
        completedList = (NSMutableArray<TodoItem *> *)[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:self.completedData error:&error];

        if (error) {
            NSLog(@"Failed to unarchive todo items: %@", error);
        }
    }
    
    return completedList;
}

- (void)savedTodoListWithTitle:(NSString *)title content:(NSString *)content date:(NSDate *)date {
    self.savedData = [self.defaults objectForKey:@"todoItems"];
    NSMutableArray<TodoItem *> *todoItems;

    if (self.savedData) {
        NSError *error;
        NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [TodoItem class], [NSString class], [NSDate class], nil];
        todoItems = (NSMutableArray<TodoItem *> *)[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:self.savedData error:&error];

        if (error) {
            NSLog(@"Failed to unarchive todo items: %@", error);
            todoItems = [NSMutableArray array];
        }
    } else {
        todoItems = [NSMutableArray array];
    }

    // Create a new TodoItem
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    // 将 NSTimeInterval 转换为 NSInteger（整数类型）
    NSInteger timeStamp = (NSInteger)timeInterval;
    int newNo = (int)(timeStamp); // Generate a new 'no' based on the count
    TodoItem *newItem = [[TodoItem alloc] initWithNo:newNo title:title content:content date:date];

    // Add the new item to the array
    [todoItems addObject:newItem];

    // Serialize the updated array and save it back to NSUserDefaults
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:todoItems requiringSecureCoding:YES error:&error];

    if (!error) {
        [self.defaults setObject:data forKey:@"todoItems"];
        [self.defaults synchronize];
        self.savedData = data; // update savedData
        NSLog(@"Called Saved Data: %@", self.savedData);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ListUpdated" object:nil];
    } else {
        NSLog(@"Failed to archive todo items: %@", error);
    }
}


- (void)savedCompletedListWithTitle:(NSString *)title content:(NSString *)content date:(NSDate *)date {
    self.completedData = [self.defaults objectForKey:@"completedItems"];
    NSMutableArray<TodoItem *> *todoItems;

    if (self.completedData) {
        NSError *error;
        NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [TodoItem class], [NSString class], [NSDate class], nil];
        todoItems = (NSMutableArray<TodoItem *> *)[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:self.completedData error:&error];

        if (error) {
            NSLog(@"Failed to unarchive todo items: %@", error);
            todoItems = [NSMutableArray array];
        }
    } else {
        todoItems = [NSMutableArray array];
    }

    // Create a new TodoItem
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    // 将 NSTimeInterval 转换为 NSInteger（整数类型）
    NSInteger timeStamp = (NSInteger)timeInterval;
    int newNo = (int)(timeStamp); // Generate a new 'no' based on the count
    TodoItem *newItem = [[TodoItem alloc] initWithNo:newNo title:title content:content date:date];

    // Add the new item to the array
    [todoItems addObject:newItem];

    // Serialize the updated array and save it back to NSUserDefaults
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:todoItems requiringSecureCoding:YES error:&error];

    if (!error) {
        [self.defaults setObject:data forKey:@"completedItems"];
        [self.defaults synchronize];
        self.completedData = data; // update savedData
        NSLog(@"Called Saved Data: %@", self.savedData);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CompletedListUpdated" object:nil];
    } else {
        NSLog(@"Failed to archive todo items: %@", error);
    }
}

- (void)removeItemWithNo:(int)itemNo {
    self.savedData = [self.defaults objectForKey:@"todoItems"];
    NSMutableArray<TodoItem *> *todoItems;

    if (self.savedData) {
        NSError *error;
        NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [TodoItem class], [NSString class], [NSDate class], nil];
        todoItems = (NSMutableArray<TodoItem *> *)[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:self.savedData error:&error];

        if (error) {
            NSLog(@"Failed to unarchive todo items: %@", error);
            return;
        }
    } else {
        todoItems = [NSMutableArray array];
    }

    // Find the item to remove
    TodoItem *itemToRemove = nil;
    for (TodoItem *item in todoItems) {
        if (item.no == itemNo) {
            itemToRemove = item;
            break;
        }
    }

    if (itemToRemove) {
        [todoItems removeObject:itemToRemove];

        // Serialize the updated array and save it back to NSUserDefaults
        NSError *error;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:todoItems requiringSecureCoding:YES error:&error];

        if (!error) {
            [self.defaults setObject:data forKey:@"todoItems"];
            [self.defaults synchronize];
            self.savedData = data; // update savedData
            NSLog(@"Removed item No: %d", itemNo);
        } else {
            NSLog(@"Failed to archive todo items: %@", error);
        }
    } else {
        NSLog(@"Item with No: %d not found", itemNo);
    }
}

- (void)removeCompletedItemWithNo:(int)itemNo {
    self.completedData = [self.defaults objectForKey:@"completedItems"];
    NSMutableArray<TodoItem *> *todoItems;

    if (self.completedData) {
        NSError *error;
        NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [TodoItem class], [NSString class], [NSDate class], nil];
        todoItems = (NSMutableArray<TodoItem *> *)[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:self.completedData error:&error];

        if (error) {
            NSLog(@"Failed to unarchive todo items: %@", error);
            return;
        }
    } else {
        todoItems = [NSMutableArray array];
    }

    // Find the item to remove
    TodoItem *itemToRemove = nil;
    for (TodoItem *item in todoItems) {
        if (item.no == itemNo) {
            itemToRemove = item;
            break;
        }
    }

    if (itemToRemove) {
        [todoItems removeObject:itemToRemove];

        // Serialize the updated array and save it back to NSUserDefaults
        NSError *error;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:todoItems requiringSecureCoding:YES error:&error];

        if (!error) {
            [self.defaults setObject:data forKey:@"completedItems"];
            [self.defaults synchronize];
            self.completedData = data; // update savedData
            NSLog(@"Removed item No: %d", itemNo);
        } else {
            NSLog(@"Failed to archive todo items: %@", error);
        }
    } else {
        NSLog(@"Item with No: %d not found", itemNo);
    }
}


- (void)resetTodoList {
    self.savedData = [self.defaults objectForKey:@"todoItems"];
    [self.defaults removeObjectForKey:@"todoItems"];
    [self.defaults synchronize]; // Ensure changes are saved immediately
    self.savedData = nil;         // Update savedData to reflect the reset states
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ListUpdated" object:nil];
}

- (void)resetCompletedList {
    self.completedData = [self.defaults objectForKey:@"completedItems"];
    [self.defaults removeObjectForKey:@"completedItems"];
    [self.defaults synchronize]; // Ensure changes are saved immediately
    self.completedData = nil;         // Update savedData to reflect the reset states
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CompletedListUpdated" object:nil];
}

@end
