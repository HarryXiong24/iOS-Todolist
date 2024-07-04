//
//  CreateTodoControllerViewController.m
//  XTodo
//

#import "EditTodoViewController.h"


@interface EditTodoViewController ()

@property (nonatomic, readwrite) int no;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextField *contentTextField;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) StoreOperation *operation;

@end

@implementation EditTodoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.title = @"Add New";

	// left button
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCreate)];
	self.navigationItem.leftBarButtonItem = leftButton;

	// right button
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneCreate)];
	self.navigationItem.rightBarButtonItem = rightButton;


	// Title input
	self.titleTextField = [[UITextField alloc] init];
	self.titleTextField.borderStyle = UITextBorderStyleRoundedRect;
	self.titleTextField.placeholder = @"Title";
	[self.view addSubview: self.titleTextField];

	[self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
	         make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
	         make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
	         make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20);
	 }];

	// Description input
	self.contentTextField = [[UITextField alloc] init];
	self.contentTextField.borderStyle = UITextBorderStyleRoundedRect;
	self.contentTextField.placeholder = @"Content";
	[self.view addSubview:self.contentTextField];

	[self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
	         make.top.equalTo(self.titleTextField.mas_bottom).offset(10);
	         make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
	         make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20);
	         make.height.mas_equalTo(100);
	 }];


	// Time input
	self.datePicker = [[UIDatePicker alloc] init];
	self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
	[self.view addSubview:self.datePicker];

	[self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
	         make.top.equalTo(self.contentTextField.mas_bottom).offset(10);
	         make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
	 }];

	// delegate
	self.operation = [[StoreOperation alloc] init];

}

- (void) cancelCreate {

	// if I use NavigationBar
	//	[self.navigationController popViewControllerAnimated:YES];

	// normal way
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) doneCreate {
	NSString *title = self.titleTextField.text;
	NSString *content = self.contentTextField.text;
	NSDate *date = self.datePicker.date;

	// Validate inputs
	if (title.length == 0 || [[title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
		[self showAlertWithTitle:@"Missing Title" message:@"Please enter a title for your Todo item."];
		return;
	}

	if (content.length == 0 || [[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
		[self showAlertWithTitle:@"Missing Content" message:@"Please enter some content for your Todo item."];
		return;
	}

	if (date == nil) {
		[self showAlertWithTitle:@"Missing Date" message:@"Please select a date for your Todo item."];
		return;
	}
    
    if (self.isEdit && self.no) {
        [self.operation removeItemWithNo:(int)self.no];
    }
	// Save date to TodoItem objects
	[self.operation savedTodoListWithTitle:title content:content date:date];

	// if I use NavigationBar
	//	[self.navigationController popViewControllerAnimated:YES];

	// normal way
	[self dismissViewControllerAnimated: YES completion: nil];
}

- (void) update:(TodoItem *)todoItem {

	if (!todoItem.no || !todoItem.title || !todoItem.content || !todoItem.date) {
		[self showAlertWithTitle:@"Missing Data" message:@"Error!"];
		return;
	}

	dispatch_async(dispatch_get_main_queue(), ^{
        self.no = todoItem.no;
        self.navigationItem.title = @"Update";
		self.titleTextField.text = todoItem.title;
		self.contentTextField.text = todoItem.content;
		self.datePicker.date = todoItem.date;
		NSLog(@"Done update todoItem");
	});

}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
	                                      message:message
	                                      preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
	[alertController addAction:okAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

@end
