#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>

// Khai báo giao diện Cài đặt Trợ năng gốc để chèn thêm tùy chọn của bạn
@interface AccessibilityController : PSListController
- (id)specifiers;
@end

%hook AccessibilityController

- (id)specifiers {
    id orig = %orig;
    if (!orig) return orig;

    // Tạo một specifier (mục bấm) mới nằm trong Trợ năng
    PSSpecifier *unlockSpecifier = [PSSpecifier preferenceSpecifierNamed:@"Mở khóa toàn bộ App"
                                                                 target:self
                                                                    set:NULL
                                                                    get:NULL
                                                                 detail:Nil
                                                                   cell:PSButtonCell
                                                                   edit:Nil];
    
    // Gán hành động khi nhấn vào nút
    [unlockSpecifier setProperty:@selector(handleUnlockAction:) forKey:@"action"];
    
    // Chèn specifier vào danh sách (ví dụ: chèn vào đầu hoặc cuối trang Trợ năng)
    [(NSMutableArray *)orig insertObject:unlockSpecifier atIndex:0];

    return orig;
}

%new
- (void)handleUnlockAction:(PSSpecifier *)sender {
    // Đoạn mã xử lý khi người dùng bấm nút mở khóa:
    // Bạn có thể gọi các hàm hệ thống quản lý Screen Time (như CoreDuet hoặc các tiến trình SpringBoard)
    // để gỡ bỏ giới hạn thời gian hoặc làm mới trạng thái ứng dụng.
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Đã kích hoạt"
                                                                   message:@"Đã gửi lệnh vô hiệu hóa giới hạn Screen Time!"
                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

%end
