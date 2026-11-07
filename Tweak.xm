#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>

@interface PSSpecifier (ScreenTimeUnlocker)
- (void)setAction:(SEL)action;
- (void)setTarget:(id)target;
@end

@interface PSListController (ScreenTimeUnlocker)
- (void)reloadSpecifiers;
@end

// Hook vào controller tổng của ứng dụng Cài đặt
%hook PSListController

- (NSMutableArray *)specifiers {
    NSMutableArray *specifiers = %orig;
    if (!specifiers) return nil;

    // Kiểm tra để tránh thêm trùng lặp nút bấm
    static NSString *const kUnlockSpecifierID = @"ScreenTimeUnlockerButton";
    for (PSSpecifier *spec in specifiers) {
        if ([[spec identifier] isEqualToString:kUnlockSpecifierID]) {
            return specifiers;
        }
    }

    // Tạo nút bấm ScreenTimeUnlocker
    PSSpecifier *unlockSpecifier = [PSSpecifier preferenceSpecifierNamed:@"Mở khóa Screen Time"
                                                                   target:self
                                                                      set:NULL
                                                                      get:NULL
                                                                   detail:Nil
                                                                     cell:PSButtonCell
                                                                     edit:Nil];
    [unlockSpecifier setIdentifier:kUnlockSpecifierID];
    [unlockSpecifier setTarget:self];
    [unlockSpecifier setAction:@selector(handleScreenTimeUnlockAction:)];

    // Chèn nút lên ngay đầu danh sách
    [specifiers insertObject:unlockSpecifier atIndex:0];

    return specifiers;
}

%new
- (void)handleScreenTimeUnlockAction:(PSSpecifier *)specifier {
    (void)specifier;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ScreenTimeUnlocker"
                                                                    message:@"Đã kích hoạt phím tắt mở khóa!"
                                                                     preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Đồng ý" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];

    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            keyWindow = window;
            break;
        }
    }
    [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

%end
