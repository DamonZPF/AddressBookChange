//
//  ViewController.m
//  AddressBookChange
//
//  Created by zhoupengfei on 15/5/25.
//  Copyright (c) 2015年 zpf. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)addressBookAction:(id)sender {
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        // 授权失败 直接返回
        return;
    }
    
    ABAddressBookRef ref = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(ref);
    CFIndex count = CFArrayGetCount(arrayRef);
    
    for (int i =0 ; i < count; i++) {
        ABRecordRef recordRef = CFArrayGetValueAtIndex(arrayRef, i);
        ABMultiValueRef  phones =  ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
        
        //获取当前联系总共有多少中电话
        CFIndex phoneCounts = ABMultiValueGetCount(phones);
        for (int j = 0 ; j < phoneCounts; j++) {
            
            ABMultiValueRef  mutiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            CFStringRef name = ABMultiValueCopyLabelAtIndex(phones, j);
            CFStringRef value = ABMultiValueCopyValueAtIndex(phones, j);
        
            NSLog(@"____%@____%@",name,value);
            ABMultiValueAddValueAndLabel(mutiValue, @"12345678", kABPersonPhoneMobileLabel, NULL);
             ABRecordSetValue(recordRef, kABPersonPhoneProperty, phones, NULL);
        }
        ABAddressBookSave(ref, NULL);
    }
    
   
    
    if (ref) {
        CFRelease(ref);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
       // 授权成功 直接返回
        return;
    }
    
    ABAddressBookRef  bookref = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(bookref, ^(bool granted, CFErrorRef error) {
       if (granted) { //授权成功
           NSLog(@"______授权成功");
       }else{
           NSLog(@"______授权失败");
       }
   });
}



@end
