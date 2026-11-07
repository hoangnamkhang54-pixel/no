#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>

// Khai báo interface mở rộng cho PSListController nếu cần
@interface PSListController (ScreenTimeUnlocker)
- (void)reloadSpecifiers;
@end

// Hook vào AccessibilityController (hoặc PSListController nếu muốn áp dụng rộng rãi)
%hook AccessibilityController

- (NSArray *)specifiers {
    NSArray *origSpecifiers = %orig;
    if (!origSpecifiers) {
        return nil;
    }

    // Tạo bản sao mutable để chèn thêm tùy chỉnh của chúng ta
    NSMutableArray *mutableSpecifiers = [origSpecifiers mutableCopy];

    // Khởi tạo PSSpecifier dạng nút bấm (PSButtonCell) chuyên nghiệp
    PSSpecifier *unlockSpecifier = [PSSpecifier preferenceSpecifierNamed:@"Mở khóa Screen Time"
                                                                   target:self
                                                                      set:NULL
                                                                      get:NULL
                                                                   detail:Nil
                                                                     cell:PSButtonCell
                                                                     edit:Nil];

    // Gắn Target và Action chuẩn xác (Tránh hoàn toàn lỗi truyền trực tiếp rvalue SEL sang id)
    [unlockSpecifier setTarget:self];
    [unlockSpecifier setAction:@selector(handleScreenTimeUnlockAction:)];

    // Chèn specifier mới lên vị trí đầu tiên trong mục Trợ năng
    [mutableSpecifiers insertObject:unlockSpecifier atIndex:0];

    return mutableSpecifiers;
}

// Định nghĩa phương thức mới tiêm vào runtime bằng từ khóa %new của Logos
%new
- (void)handleScreenTimeUnlockAction:(PSSpecifier *)specifier {
    // Tạo bảng thông báo (Alert) xác nhận khi người dùng bấm vào nút Trợ năng tùy chỉnh
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Screen Time Unlocker"
                                                                    message:@"Đã kích hoạt phím tắt quản lý Giờ sử dụng hệ thống!"
                                                                     preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Đồng ý" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
        // Chèn logic xử lý mở khóa hoặc gọi các hàm hệ thống tại đây nếu cần
        NSLog(@"[ScreenTimeUnlocker] Nút mở khóa đã được kích hoạt thành công!");
    }];

    [alert addAction:okAction];

    // Lấy cửa sổ chính của ứng dụng Cài đặt (Settings) để hiển thị Alert an toàn
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
