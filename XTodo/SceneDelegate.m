//
//  SceneDelegate.m
//  XTodo
//

#import "Controllers/CompletedViewController.h"
#import "Controllers/TasksViewController.h"
#import "Models/StoreOperation.h"
#import "SceneDelegate.h"

@interface SceneDelegate ()

@property (nonatomic, strong) UITabBarController *rootVC;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];

    self.rootVC = [[UITabBarController alloc] init];
    UIFont *font = [UIFont systemFontOfSize:14];
    NSDictionary *attributes = @{
            NSFontAttributeName: font
    };
    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateSelected];

    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -16, CGRectGetWidth(self.rootVC.tabBar.bounds), 1)];
    self.lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [self.rootVC.tabBar addSubview:self.lineView];

    // Add an observer for screen rotation
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLineViewFrame)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

    TasksViewController *overallVC = [[TasksViewController alloc] init];
    UINavigationController *overallNVC = [[UINavigationController alloc] initWithRootViewController:overallVC];
    overallNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Tasks" image:[UIImage systemImageNamed:@"list.star"] selectedImage:[UIImage systemImageNamed:@"list.star.fill"]];

    CompletedViewController *completedVC = [[CompletedViewController alloc] init];
    UINavigationController *completedNVC = [[UINavigationController alloc] initWithRootViewController:completedVC];
    completedVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Completed" image:[UIImage systemImageNamed:@"calendar.badge.checkmark"] selectedImage:[UIImage systemImageNamed:@"calendar.badge.checkmarkfill"]];

    [self.rootVC setViewControllers:@[overallNVC, completedNVC]];

    self.window.rootViewController = self.rootVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (void)updateLineViewFrame {
    // Adjust the frame of lineView when the screen rotates
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect newFrame = self.lineView.frame;
        newFrame.size.width = CGRectGetWidth(self.rootVC.tabBar.bounds);
        self.lineView.frame = newFrame;
    });
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).

    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}

- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}

@end
