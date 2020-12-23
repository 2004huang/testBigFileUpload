//
//  ChatViewController.m
//  TUIKitDemo
//
//  Created by kennethmiao on 2018/10/10.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "ChatViewController.h"
#import "GroupInfoController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TVideoMessageCell.h"
#import "TFileMessageCell.h"
#import "TLoactionMessageCell.h"
#import "ImageViewController.h"
#import "VideoViewController.h"
#import "FileViewController.h"
#import "TUserProfileController.h"
#import "SIMChatMapViewController.h"
//#import <ImSDK/ImSDK.h>
#import "SIMSendMapViewController.h"
@interface ChatViewController () <TChatControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate,SIMSendMapViewDelegate>
@property (nonatomic, strong) TChatController *chat;
@end

@implementation ChatViewController
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTintColor:BlueButtonColor];
//    self.navigationController.navigationBar.titleTextAttributes=
//    @{NSForegroundColorAttributeName:NewBlackTextColor,
//      NSFontAttributeName:FontRegularName(18)};
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:ZJYColorHex(@"#f4f3f3")]];
//
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _chat = [[TChatController alloc] init];
    _chat.conversation = _conversation;
    _chat.delegate = self;
    [self addChildViewController:_chat];
    [self.view addSubview:_chat.view];
    // 如果是会议内部界面的话 那么是返回是dismiss
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnicon"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
}
- (void)backClick {
    if (self.isConfVC) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)chatControllerDidClickRightBarButton:(TChatController *)controller
{
    if (_conversation.convType == TConv_Type_C2C) {
        
        [[TIMFriendshipManager sharedInstance] getUsersProfile:@[_conversation.convId] forceUpdate:YES succ:^(NSArray<TIMUserProfile *> *profiles) {
            TUserProfileController *myProfile = [[TUserProfileController alloc] init];
            myProfile.profile = profiles.firstObject;
            [self.navigationController pushViewController:myProfile animated:YES];
        } fail:^(int code, NSString *msg) {
            
        }];
        
    } else {
        GroupInfoController *groupInfo = [[GroupInfoController alloc] init];
        groupInfo.groupId = _conversation.convId;
        [self.navigationController pushViewController:groupInfo animated:YES];
    }
}

- (void)chatController:(TChatController *)chatController didSelectMoreAtIndex:(NSInteger)index
{
    NSLog(@"didchatmoreindex %ld",(long)index);
    if(index == 0 || index == 2 || index == 4){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if(index == 0){
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else if(index == 2){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.cameraCaptureMode =UIImagePickerControllerCameraCaptureModePhoto;
        }
        else{
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            picker.cameraCaptureMode =UIImagePickerControllerCameraCaptureModeVideo;
            picker.videoQuality =UIImagePickerControllerQualityTypeHigh;
        }
        picker.delegate = self;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:picker animated:YES completion:nil];
    }else if(index == 6){
        UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[(NSString *)kUTTypeData] inMode:UIDocumentPickerModeOpen];
        picker.delegate = self;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:picker animated:YES completion:nil];
    }else if(index == 1){
        NSLog(@"发送地理位置");
        SIMSendMapViewController *mapVC = [[SIMSendMapViewController alloc] init];
        mapVC.delegate = self;
        [self.navigationController pushViewController:mapVC animated:YES];

    }
//    if(index == 0 || index == 1 || index == 2){
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        if(index == 0){
//            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//        }
//        else if(index == 1){
//            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            picker.cameraCaptureMode =UIImagePickerControllerCameraCaptureModePhoto;
//        }
//        else{
//            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//            picker.cameraCaptureMode =UIImagePickerControllerCameraCaptureModeVideo;
//            picker.videoQuality =UIImagePickerControllerQualityTypeHigh;
//        }
//        picker.delegate = self;
//        [self presentViewController:picker animated:YES completion:nil];
//    }else {
//        UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[(NSString *)kUTTypeData] inMode:UIDocumentPickerModeOpen];
//        picker.delegate = self;
//        [self presentViewController:picker animated:YES completion:nil];
//    }
}
- (void)buttonNowLoactionWithLat:(double)latitude andLon:(double)longitude locationStr:(NSString *)locationStr {
    NSLog(@"当前的位置呀22222location:{lat:%f; lon:%f;} %@",latitude,longitude,locationStr);
    [_chat sendLocationMessage:@{@"locationStr":locationStr,@"latitude":@(latitude),@"longitude":@(longitude)}];
}
- (void)chatController:(TChatController *)chatController didSelectMessages:(NSMutableArray *)msgs atIndex:(NSInteger)index
{
    TMessageCellData *data = msgs[index];
    if([data isKindOfClass:[TImageMessageCellData class]]){
        ImageViewController *image = [[ImageViewController alloc] init];
        image.data = (TImageMessageCellData *)data;
        image.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:image animated:YES completion:nil];
    }
    else if([data isKindOfClass:[TVideoMessageCellData class]]){
        VideoViewController *video = [[VideoViewController alloc] init];
        video.data = (TVideoMessageCellData *)data;
        video.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:video animated:YES completion:nil];
    }
    else if([data isKindOfClass:[TFileMessageCellData class]]){
        FileViewController *file = [[FileViewController alloc] init];
        file.data = (TFileMessageCellData *)data;
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:file];
//        [self presentViewController:nav animated:YES completion:nil];
        [self.navigationController pushViewController:file animated:YES];
    }
    else if([data isKindOfClass:[TLoactionMessageCellData class]]){
        NSLog(@"点击了那个发送地理位置");
        SIMChatMapViewController *chatMapVC = [[SIMChatMapViewController alloc] init];
        chatMapVC.data = (TLoactionMessageCellData *)data;
        [self.navigationController pushViewController:chatMapVC animated:YES];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageOrientation imageOrientation=  image.imageOrientation;
        if(imageOrientation != UIImageOrientationUp)
        {
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }

        [_chat sendImageMessage:image];
    }
    else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        [_chat sendVideoMessage:url];
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    [_chat sendFileMessage:url];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)getLocalPath:(NSURL *)url
{
    NSString *imageName = [url lastPathComponent];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    return localFilePath;
}
@end
