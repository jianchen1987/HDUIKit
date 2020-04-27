//
//  HDKeyboardManager.m
//  HDUIKit
//
//  Created by VanJay on 2020/4/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDKeyboardManager.h"
#import "HDKeyboardManager+Helper.h"
#import "HDKeyboardManagerDefines.h"

@interface HDKeyboardManager () <UIGestureRecognizerDelegate>
@property (nullable, nonatomic, weak) UIView *textFieldView;
@property (nonnull, nonatomic, strong, readwrite) UITapGestureRecognizer *resignFirstResponderGesture;

@property (nonatomic, strong, nonnull, readwrite) NSMutableSet<Class> *disabledTouchResignedClasses;
@property (nonatomic, strong, nonnull, readwrite) NSMutableSet<Class> *enabledTouchResignedClasses;
@property (nonatomic, strong, nonnull, readwrite) NSMutableSet<Class> *touchResignedGestureIgnoreClasses;
@end

@implementation HDKeyboardManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HDKeyboardManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        [instance registerAllNotifications];

        instance.resignFirstResponderGesture = [[UITapGestureRecognizer alloc] initWithTarget:instance action:@selector(tapRecognized:)];
        instance.resignFirstResponderGesture.cancelsTouchesInView = NO;
        [instance.resignFirstResponderGesture setDelegate:instance];
        instance.resignFirstResponderGesture.enabled = instance.shouldResignOnTouchOutside;

        instance.disabledTouchResignedClasses = [[NSMutableSet alloc] initWithObjects:[UIAlertController class], nil];
        instance.enabledTouchResignedClasses = [[NSMutableSet alloc] init];
        instance.touchResignedGestureIgnoreClasses = [[NSMutableSet alloc] initWithObjects:[UIControl class], [UINavigationBar class], nil];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

#pragma mark - Notification
- (void)registerAllNotifications {

    [self registerTextFieldViewClass:[UITextField class]
        didBeginEditingNotificationName:UITextFieldTextDidBeginEditingNotification
          didEndEditingNotificationName:UITextFieldTextDidEndEditingNotification];

    [self registerTextFieldViewClass:[UITextView class]
        didBeginEditingNotificationName:UITextViewTextDidBeginEditingNotification
          didEndEditingNotificationName:UITextViewTextDidEndEditingNotification];
}

- (void)unregisterAllNotifications {

    [self unregisterTextFieldViewClass:[UITextField class]
        didBeginEditingNotificationName:UITextFieldTextDidBeginEditingNotification
          didEndEditingNotificationName:UITextFieldTextDidEndEditingNotification];

    [self unregisterTextFieldViewClass:[UITextView class]
        didBeginEditingNotificationName:UITextViewTextDidBeginEditingNotification
          didEndEditingNotificationName:UITextViewTextDidEndEditingNotification];
}

#pragma mark - private methods
- (void)registerTextFieldViewClass:(nonnull Class)aClass
    didBeginEditingNotificationName:(nonnull NSString *)didBeginEditingNotificationName
      didEndEditingNotificationName:(nonnull NSString *)didEndEditingNotificationName {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:didBeginEditingNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidEndEditing:) name:didEndEditingNotificationName object:nil];
}

- (void)unregisterTextFieldViewClass:(nonnull Class)aClass
     didBeginEditingNotificationName:(nonnull NSString *)didBeginEditingNotificationName
       didEndEditingNotificationName:(nonnull NSString *)didEndEditingNotificationName {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didBeginEditingNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didEndEditingNotificationName object:nil];
}

- (BOOL)resignFirstResponder {
    UIView *textFieldView = _textFieldView;
    if (textFieldView) {
        UIView *textFieldRetain = textFieldView;
        BOOL isResignFirstResponder = [textFieldView resignFirstResponder];
        if (isResignFirstResponder == NO) {
            [textFieldRetain becomeFirstResponder];
        }
        return isResignFirstResponder;
    } else {
        return NO;
    }
}

- (BOOL)privateShouldResignOnTouchOutside {
    BOOL shouldResignOnTouchOutside = _shouldResignOnTouchOutside;
    __strong __typeof__(UIView) *strongTextFieldView = _textFieldView;
    HDKMEnableMode enableMode = strongTextFieldView.shouldResignOnTouchOutsideMode;
    if (enableMode == HDKMEnableModeEnabled) {
        shouldResignOnTouchOutside = YES;
    } else if (enableMode == HDKMEnableModeDisabled) {
        shouldResignOnTouchOutside = NO;
    } else {
        UIViewController *textFieldViewController = [strongTextFieldView viewContainingController];
        if (textFieldViewController) {
            if ([strongTextFieldView textFieldSearchBar] != nil && [textFieldViewController isKindOfClass:[UINavigationController class]]) {

                UINavigationController *navController = (UINavigationController *)textFieldViewController;
                if (navController.topViewController) {
                    textFieldViewController = navController.topViewController;
                }
            }

            if (shouldResignOnTouchOutside == NO) {
                for (Class enabledClass in _enabledTouchResignedClasses) {
                    if ([textFieldViewController isKindOfClass:enabledClass]) {
                        shouldResignOnTouchOutside = YES;
                        break;
                    }
                }
            }

            if (shouldResignOnTouchOutside) {
                for (Class disabledClass in _disabledTouchResignedClasses) {
                    if ([textFieldViewController isKindOfClass:disabledClass]) {
                        shouldResignOnTouchOutside = NO;
                        break;
                    }
                }

                if (shouldResignOnTouchOutside == YES) {
                    NSString *classNameString = NSStringFromClass([textFieldViewController class]);

                    if ([classNameString containsString:@"UIAlertController"] && [classNameString hasSuffix:@"TextFieldViewController"]) {
                        shouldResignOnTouchOutside = NO;
                    }
                }
            }
        }
    }

    return shouldResignOnTouchOutside;
}

#pragma mark - event response
- (void)tapRecognized:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self resignFirstResponder];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    for (Class aClass in self.touchResignedGestureIgnoreClasses) {
        if ([[touch view] isKindOfClass:aClass]) {
            return NO;
        }
    }

    return YES;
}

#pragma mark - UITextField/UITextview DidBeginEditing NSNotification
- (void)textFieldViewDidBeginEditing:(NSNotification *)notification {

    _textFieldView = notification.object;
    UIView *textFieldView = _textFieldView;

    [_resignFirstResponderGesture setEnabled:[self privateShouldResignOnTouchOutside]];
    [textFieldView.window addGestureRecognizer:_resignFirstResponderGesture];
}

#pragma mark - UITextField/UITextview DidEndEditing NSNotification
- (void)textFieldViewDidEndEditing:(NSNotification *)notification {
    UIView *textFieldView = _textFieldView;
    [textFieldView.window removeGestureRecognizer:_resignFirstResponderGesture];
}
@end
