//
//  CompletedTableViewCell.m
//  XTodo
//

#import "CompletedViewController.h"

@interface CompletedViewController () <UITableViewDataSource, UITableViewDelegate, CompletedItemViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic, readwrite) NSMutableArray<TodoItem *> *completedList;
@property (strong, nonatomic, readwrite) StoreOperation *dataOperation;

@end

@implementation CompletedViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	// add observer
	self.dataOperation = [[StoreOperation alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"CompletedListUpdated" object:nil];

	// title and style
	self.navigationItem.title = @"Completed";
	NSDictionary *titleAttributes = @{
		NSForegroundColorAttributeName: [UIColor blackColor],
		NSFontAttributeName: [UIFont boldSystemFontOfSize:24]
	};
	self.navigationController.navigationBar.titleTextAttributes = titleAttributes;

	// todo list
	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view.mas_height);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];

	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	[self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.completedList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodoItemViewCell *cell = [[TodoItemViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
    
//    cell.delegate = self;
    cell.completedDelegate = self;

	TodoItem *item = [self.completedList objectAtIndex:indexPath.row];

	[cell layoutTableViewCell:item isSelected:true];

	return cell;
}

- (void)completedItemViewCell:(TodoItemViewCell *)cell didTapCheckbox:(UIButton *)checkbox isSelected:(BOOL)selected {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath && !selected) {
        TodoItem *todoItem = self.completedList[indexPath.row];
        [self.dataOperation removeCompletedItemWithNo:todoItem.no];
        [self.dataOperation savedTodoListWithTitle:todoItem.title content:todoItem.content date:todoItem.date];
        [self reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ListUpdated" object:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
	// create delete option
	UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {


	                                            // remove item
	                                            TodoItem *item = [self.completedList objectAtIndex:indexPath.row];

	                                            [self.dataOperation removeCompletedItemWithNo:item.no];

	                                            [self.completedList removeObjectAtIndex:indexPath.row];
	                                            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

	                                            completionHandler(YES);
					    }];

	UIContextualAction *detailAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Detail" handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {


	                                            TodoItem *item = [self.completedList objectAtIndex:indexPath.row];

	                                            DetailTableViewCell *detialTodoVC = [[DetailTableViewCell alloc] initWithDate:item];
	                                            detialTodoVC.modalPresentationStyle = UIModalPresentationFormSheet;

	                                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detialTodoVC];
	                                            [self.navigationController presentViewController:nav animated: YES completion: nil];

	                                            completionHandler(YES);
					    }];
	detailAction.backgroundColor = [UIColor blueColor];

	// return
	UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction, detailAction]];
	return configuration;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	TodoItem *item = [self.completedList objectAtIndex:indexPath.row];

	DetailTableViewCell *detialTodoVC = [[DetailTableViewCell alloc] initWithDate:item];
	detialTodoVC.modalPresentationStyle = UIModalPresentationFormSheet;

	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detialTodoVC];
	[self.navigationController presentViewController:nav animated: YES completion: nil];
}


- (void) reloadData {
	self.completedList = [self.dataOperation getCompletedList];
	[self.tableView reloadData];
}



@end
