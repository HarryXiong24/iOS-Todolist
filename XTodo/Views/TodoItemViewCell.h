//
//  TodoItemViewCell.h
//  XTodo
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "../Models/TodoItem.h"
#import "../Models/StoreOperation.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TodoItemViewCellDelegate;
@protocol CompletedItemViewCellDelegate;

@interface TodoItemViewCell : UITableViewCell

@property (nonatomic, weak) id<TodoItemViewCellDelegate> todoDelegate;
@property (nonatomic, weak) id<CompletedItemViewCellDelegate> completedDelegate;

- (void)layoutTableViewCell:(TodoItem *)todoItem isSelected:(BOOL)isSelected;
- (void)checkboxTapped:(UIButton *)sender;

@end

@protocol TodoItemViewCellDelegate <NSObject>

- (void)todoItemViewCell:(TodoItemViewCell *)cell didTapCheckbox:(UIButton *)checkbox isSelected:(BOOL)selected;

@end

@protocol CompletedItemViewCellDelegate <NSObject>

- (void)completedItemViewCell:(TodoItemViewCell *)cell didTapCheckbox:(UIButton *)checkbox isSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
