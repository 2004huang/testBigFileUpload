//
//  SIMCloudVersion.m
//  Kaihuibao
//
//  Created by mac126 on 2019/6/14.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMCloudVersion.h"

@implementation SIMCloudVersion
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"register"]) {
        [self setValue:value forKey:@"registerBtn"];
    }
    if ([key isEqualToString:@"copy"]) {
        [self setValue:value forKey:@"pasteBoard"];
    }
    
}

- (NSString *)avatar_show {
    if (_avatar_show == nil) {
        _avatar_show = @"1";
    }
    return _avatar_show;
}
- (NSString *)avatar_update {
    if (_avatar_update == nil) {
        _avatar_update = @"1";
    }
    return _avatar_update;
}
- (NSString *)nickname_show {
    if (_nickname_show == nil) {
        _nickname_show = @"1";
    }
    return _nickname_show;
}
- (NSString *)nickname_update {
    if (_nickname_update == nil) {
        _nickname_update = @"1";
    }
    return _nickname_update;
}
- (NSString *)companyname_show {
    if (_companyname_show == nil) {
        _companyname_show = @"1";
    }
    return _companyname_show;
}
- (NSString *)companyname_update {
    if (_companyname_update == nil) {
        _companyname_update = @"1";
    }
    return _companyname_update;
}
- (NSString *)update_password {
    if (_update_password == nil) {
        _update_password = @"1";
    }
    return _update_password;
}


- (instancetype)initWithDeflaut {
    self = [super init];
    if (self) {
        _version = @"public";
        _join_meeting = @"1";
        _im = @"1";
        _start_meeting = @"1";
        _arrange_meeting = @"1";
        _map_position = @"1";
        _address_book = @"1";
        _about = @"1";
        _captcha_login = @"1";
        _change_company = @"1";
        _forget_password = @"1";
        _online_experience = @"1";
        _plan = @"1";
        _registerBtn = @"1";
        _third_login = @"1";
        _start_img = @"1";
        _contacts = @"1";
        _email = @"1";
        _invite = @"1";
        _message = @"1";
        _myfriend = @"1";
        _pasteBoard = @"1";
        _wechat = @"1";
        _username_type = @"default";
        _webFileUrl = @"https://doc.kaihuibao.net";
        _shareDocument = @"1";
        _shorthand = @"1";
        _find = @"1";
        _freeCamera = @"1";
        _mainBroadcast = @"1";
        _mainCamera = @"1";
        _intercom = @"1";
        _EHSfieldOperation = @"1";
        _voiceSeminar = @"1";
        _trainingConference = @"1";
        _live = @"1";
        _many_languages = @"1";
        _cloud_server = @"1";
        _password_login = @"1";
        _avatar_show = @"1";
        _avatar_update = @"1";
        _nickname_show = @"1";
        _nickname_update = @"1";
        _companyname_show = @"1";
        _companyname_update = @"1";
        _update_password = @"1";
        _username_prompt = @"mobile";
        _cloud_space = @"1";
        _feedback = @"1";
        _recommend_show = @"1";
        _recommend_content = @"";
        _homeurl_show = @"1";
        _homeurl = @"";
        _defaultConfMode = @"freeCamera";
        _privacy_path = @"/admin/index/about?t=privacy&h=1";
        _terms_path = @"/admin/index/about?t=terms&h=1";
        _special_note = @"1";
        _specialnote_content = @"";
        _specialnote_link = @"";
        _teaching_model = @"1";
        _telemedicine = @"1";
        _field_operation = @"1";
        _video_playback = @"1";
        _learning_center = @"1";
        _video_home = @"1";
        
    }
    return self;
}
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"version":@"version",
             @"join_meeting":@"join_meeting",
             @"im":@"im",
             @"start_meeting":@"start_meeting",
             @"arrange_meeting":@"arrange_meeting",
             @"map_position":@"map_position",
             @"address_book":@"address_book",
             @"about":@"about",
             @"captcha_login":@"captcha_login",
             @"change_company":@"change_company",
             @"forget_password":@"forget_password",
             @"online_experience":@"online_experience",
             @"plan":@"plan",
             @"registerBtn":@"registerBtn",
             @"third_login":@"third_login",
             @"start_img":@"start_img",
             @"contacts":@"contacts",
             @"myfriend":@"myfriend",
             @"invite":@"invite",
             @"wechat":@"wechat",
             @"email":@"email",
             @"message":@"message",
             @"pasteBoard":@"pasteBoard",
             @"username_type":@"username_type",
             @"webFileUrl":@"webFileUrl",
             @"shareDocument":@"shareDocument",
             @"shorthand":@"shorthand",
             @"find":@"find",
             @"freeCamera":@"freeCamera",
             @"mainBroadcast":@"mainBroadcast",
             @"mainCamera":@"mainCamera",
             @"intercom":@"intercom",
             @"EHSfieldOperation":@"EHSfieldOperation",
             @"voiceSeminar":@"voiceSeminar",
             @"trainingConference":@"trainingConference",
             @"live":@"live",
             @"many_languages":@"many_languages",
             @"cloud_server":@"cloud_server",
             @"password_login":@"password_login",
             @"avatar_show":@"avatar_show",
             @"avatar_update":@"avatar_update",
             @"nickname_show":@"nickname_show",
             @"nickname_update":@"nickname_update",
             @"companyname_show":@"companyname_show",
             @"companyname_update":@"companyname_update",
             @"update_password":@"update_password",
             @"username_prompt":@"username_prompt",
             @"cloud_space":@"cloud_space",
             @"feedback":@"feedback",
             @"recommend_show":@"recommend_show",
             @"recommend_content":@"recommend_content",
             @"homeurl_show":@"homeurl_show",
             @"homeurl":@"homeurl",
             @"defaultConfMode":@"defaultConfMode",
             @"privacy_path":@"privacy_path",
             @"terms_path":@"terms_path",
             @"special_note":@"special_note",
             @"specialnote_content":@"specialnote_content",
             @"specialnote_link":@"specialnote_link",
             @"teaching_model":@"teaching_model",
             @"telemedicine":@"telemedicine",
             @"field_operation":@"field_operation",
             @"video_playback":@"video_playback",
             @"learning_center":@"learning_center",
             @"video_home":@"video_home",

             };
}

@end
