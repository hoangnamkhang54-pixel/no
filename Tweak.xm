#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>

// Khai báo mở rộng interface cho PSSpecifier để compiler nhận diện các hàm ẩn/private
@interface PSSpecifier (ScreenTimeUnlocker)
- (void)setAction:(SEL)action;
- (void)setTarget:(id)target;
@end

// Khai báo PSListController nếu cần
@interface PSListController (ScreenTimeUnlocker)
- (void)reloadSpecifiers;
@end

%hook AccessibilityController

- (NSArray *)specifiers {
    NSArray *origSpecifiers = %orig;
    if (!origSpecifiers) {
        return nil;
    }

    NSMutableArray *mutableSpecifiers = [origSpecifiers mutableCopy];

    // Tạo PSSpecifier dạng nút bấm
    PSSpecifier *unlockSpecifier = [PSSpecifier preferenceSpecifierNamed:@"Mở khóa Screen Time"
                                                                   target:self
                                                                      set:NULL
                                                                      get:NULL
                                                                   detail:Nil
                                                                     cell:PSButtonCell
                                                                     edit:Nil];

    // Gắn Target và Action (Đã được khai báo category ở trên, không còn lỗi compiler)
    [unlockSpecifier setTarget:self];
    [unlockSpecifier setAction:@selector(handleScreenTimeUnlockAction:)];

    // Chèn vào vị trí đầu tiên trong mục Trợ năng
    [mutableSpecifiers insertObject:unlockSpecifier atIndex:0];

    return mutableSpecifiers;
}

%new
- (void)handleScreenTimeUnlockAction:(PSSpecifier *)specifier {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Screen Time Unlocker"
                                                                    message:@"Đã kích hoạt phím tắt quản lý Giờ sử dụng hệ thống!"
                                                                     preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Đồng ý" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
        NSLog(@"[ScreenTimeUnlocker] Nút mở khóa đã được kích hoạt thành công!");
    }];

    [alert addAction:okAction];

    UIWindow *targetWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            targetWindow = window;
            break;
        }
    }

    [targetWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

%end
