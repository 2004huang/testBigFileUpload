//
//  MainNetworkRequest.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/22.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "MainNetworkRequest.h"

@implementation MainNetworkRequest

/**
 查询服务器地址接口
 */

// 查询服务器地址接口
+ (void)searchServerRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithPostURL:search_server_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 查询延时直播和实时直播
+ (void)searchLivingRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithGetURL:search_living_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 查询现在的版本号
+ (void)searchVersionRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithGetURL:search_version_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 查询是不是私有云部署
+ (void)searchIsPrivateRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithPostURL:search_isPrivate_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 查询是否需要更新
+ (void)updateVersionRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithPostURL:update_version_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

/**
 个人信息
 */
// 验证手机号
+ (void)validationPhoneNumRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithPostURL:validation_phoneNum_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];

}
// 发送短信验证码
+ (void)sendSmsValidationRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithPostURL:send_sms_validation_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 验证验证码
+ (void)judgementSmsValidationRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithPostURL:judgement_sms_validation_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// send email validation
+ (void)sendEmailValidationRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    
}
// 注册
+ (void)registerRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithPostURL:register_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 登录
+ (void)staticLoginRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
//    stati_login_api
    [[BaseNetworking shareInstance] startWithPostURL:stati_login_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 退出登录
+ (void)logoutRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:logout_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 忘记密码
+ (void)recoverPasswordRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithPostURL:recover_password_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 完善个人信息
+ (void)perfactUserInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:perfact_userinfo_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 验证码直接登录
+ (void)captchaLoginRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithPostURL:captcha_login_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 第三方登录
+ (void)thirdLoginRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithPostURL:third_login_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 设置密码
+ (void)setPasswordRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:set_password_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// set email
+ (void)setEmailRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    
}
// set mobile
+ (void)setMobileRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    
}
// 设置个人信息
+ (void)setInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:set_info_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// set callback
+ (void)setCallbackRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    
}
// 获取用户信息
+ (void)getInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:get_info_api params:params success:^(id success) {
        mainSuccess(success);
//        NSLog(@"settingUser:%@",success);
//        // 成功
//        if ([success[@"code"] integerValue] == successCodeOK) {
//            NSLog(@"getnewuser_info:+++%@",success);
//            
//            // 字典 加入一个token值 用来初始化CCUser
//            NSMutableDictionary *dicMM = [[NSMutableDictionary alloc] initWithDictionary:success[@"data"]];
//            
//            for (int i =0; i<dicMM.count; i++) {
//                if ([[dicMM objectForKey:dicMM.allKeys[i]] isKindOfClass:[NSNumber class]]) {
//                    NSString *key = dicMM.allKeys[i];
//                    NSNumber *longn = [NSNumber numberWithLong:[[dicMM objectForKey:key] longValue]];
//                    NSString *longss = [longn stringValue];
//                    [dicMM removeObjectForKey:key];
//                    [dicMM setObject:longss forKey:key];
//                }
//            }
//            
//            if ([[dicMM objectForKey:@"avatar"] length] >0) {
//                // 将face的value取出来 然后拼接
//                NSString *faceValue = [dicMM objectForKey:@"avatar"];
//                NSString *newFaceValue = [NSString stringWithFormat:@"%@/%@",kApiBaseUrl,faceValue];
//                
//                [dicMM removeObjectForKey:@"avatar"];
//                [dicMM setObject:newFaceValue forKey:@"avatar"];
//            }
//            
//            //  登录或注册服务器默认有的参数 赋值给self.currentUser以后全局可用 主要是不可以改变
//            CCUser *myUser = [[CCUser alloc] initWithDictionary:dicMM];
//            self.currentUser = myUser;
//            
//            self.currentUser.currentCompany = self.currentCompany;
//            
//            [self.currentUser synchroinzeCurrentUser];
//            NSLog(@"newcurrentUser:+++%@",self.currentUser);
//            
//            NSLog(@"newcomcom %@ %@",self.currentUser.currentCompany.company_id,self.currentUser.currentCompany.company_name);
//            NSLog(@"newcomcomteo %@ %@", self.currentCompany.company_id, self.currentCompany.company_name);
//        }
//            
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 上传用户自己的头像
+ (void)sendMyHeaderPicRequestParams:(NSDictionary *)params bodys:(BodysBlock)mainBodys progress:(ProgressBlock)mainProgress success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startPicWithHeaderPostURL:send_my_headerPic_api params:params bodys:^(id bodys) {
        mainBodys(bodys);
    } progress:^(id progress) {
        mainProgress(progress);
    } success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 获取新头像
+ (void)getNewRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:get_info_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 查看个人会议
+ (void)getConfInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:get_conf_info_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 编辑个人会议
+ (void)editConfInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:set_conf_edit_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];

}
// 查看个人直播间
+ (void)getLiveInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:get_live_info_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 查看个人视频客服
+ (void)getServiceInfoRequestParams:(NSDictionary *)params signid:(NSString *)signID success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:get_service_info_api(signID) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 公司名称
+ (void)settingCompanyNameRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:set_company_name_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];

}
// 切换公司
+ (void)changeCompanyRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:change_company_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}


/**
 会议
 */

// 创建会议
+ (void)createConfInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:create_conf_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 会议列表
+ (void)confListRequestParams:(NSDictionary *)params start:(NSString *)startString limit:(NSString *)limitString status:(NSString *)statusString signid:(NSString *)signID success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:conf_list_api(startString,limitString,statusString,signID) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
    
}
// 会议列表 新
+ (void)newconfListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:new_conf_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 已加入会议列表
+ (void)jointConfListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:joint_conf_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];

}
// 编辑会议
+ (void)editConfListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:edit_conf_api_cid params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 会议详情
+ (void)confDetailRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    NSLog(@"confdetail_httpStr_httpStrkApiBaseUrl  %@",kApiBaseUrl);
    [[BaseNetworking shareInstance] startWithHeaderPostURL:conf_detail_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 添加会议成员
+ (void)appendMemberConfRequestParams:(NSDictionary *)params cid:(NSString *)cidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:append_member_conf_api(cidString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 删除会议成员
+ (void)removeMemberConfRequestParams:(NSDictionary *)params cid:(NSString *)cidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:remove_member_conf_api(cidString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 会议成员列表
+ (void)listMemberConfRequestParams:(NSDictionary *)params cid:(NSString *)cidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:list_member_conf_api(cidString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 删除会议
+ (void)deleteConfRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:delete_conf_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 会议配置
+ (void)configConfRequestParams:(NSDictionary *)params webStr:(NSString *)webStr success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    NSString *allStr;
//    NSString *adress = [[NSUserDefaults standardUserDefaults] objectForKey:@"OneConfServerAdress"];
    if (webStr != nil && webStr.length > 0) {
        allStr = LINK_URL(webStr, @"api/conference/config");
    }else {
        allStr = LINK_URL(kApiBaseUrl, @"api/conference/config");
    }
    [[BaseNetworking shareInstance] startWithPostURL:allStr params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 验证入会密码
+ (void)verifyPSWConfRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithPostURL:verifyPSW_conf_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}


/**
 直播接口
 */
// 新建直播
+ (void)creatNewLiveRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:creat_new_live_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 编辑直播
+ (void)editNewLiveRequestParams:(NSDictionary *)params cid:(NSString *)cidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:edit_new_live_api(cidString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 直播详情
+ (void)detailNewLiveRequestParams:(NSDictionary *)params cid:(NSString *)cidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:detail_new_live_api(cidString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 直播列表
+ (void)liveListRequestParams:(NSDictionary *)params start:(NSString *)startString limit:(NSString *)limitString status:(NSString *)statusString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    NSLog(@"pay_typepauuy_type%@",live_list_api(startString,limitString,statusString));
    [[BaseNetworking shareInstance] startWithHeaderGetURL:live_list_api(startString,limitString,statusString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 删除直播
+ (void)deleteLiveRequestParams:(NSDictionary *)params cid:(NSString *)cidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] requestDELETEDataWithUrl:delete_live_api(cidString) withParamters:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 公开直播列表
+ (void)livePublicListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:live_public_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 公开直播列表 新形式测试接口
+ (void)livePublicTestListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:live_public_test_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 分享直播
+ (void)searchAdressVideoListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:search_adress_video_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

//+ (void)testtwoAdressVideoListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
//    [[BaseNetworking shareInstance] startWithPostURL:testtwo_adress_video_api params:params success:^(id success) {
//        mainSuccess(success);
//    } failure:^(id failure) {
//        mainFailure(failure);
//    }];
//}
//+ (void)testAdressVideoListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure{
//    [[BaseNetworking shareInstance] startWithHeaderGetURL:test_adress_video_api params:params success:^(id success) {
//        mainSuccess(success);
//    } failure:^(id failure) {
//        mainFailure(failure);
//    }];
//}


/**
 联系人和讨论组
 */
//--用户
+ (void)userListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:user_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 创建用户
+ (void)userCreateRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:user_create_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 删除用户
+ (void)userDeleteRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:user_delete_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 获取公共信息接口
+ (void)userPublicinfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:user_publicinfo_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 从手机通讯录添加子用户
+ (void)userAddFromAdressRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:user_addfromAdress_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
//+ (void)userListRequestParams:(NSDictionary *)params start:(NSString *)startString limit:(NSString *)limitString certification:(NSString *)certString premium:(NSString *)premiumString role:(NSString *)roleString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
//    [[BaseNetworking shareInstance] startWithHeaderGetURL:user_list_api(startString, limitString, certString, premiumString, roleString) params:params success:^(id success) {
//        mainSuccess(success);
//    } failure:^(id failure) {
//        mainFailure(failure);
//    }];
//}

/**
 组织架构
 */
// 部门列表

+ (void)departmentGetlistRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:department_getlist_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
+ (void)newDepartmentGetlistRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:new_department_getlist_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 部门里面的人员
+ (void)departmentMemberlistRequestParams:(NSDictionary *)params did:(NSString *)didString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:department_memberList_api(didString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}


//--通讯录
// 联系人列表
//+ (void)contractorListRequestParams:(NSDictionary *)params start:(NSString *)startString limit:(NSString *)limitString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
//    [[BaseNetworking shareInstance] startWithHeaderGetURL:contractor_list_api(startString,limitString) params:params success:^(id success) {
//        mainSuccess(success);
//    } failure:^(id failure) {
//        mainFailure(failure);
//    }];
//
//}
+ (void)contractorListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:contractor_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 删除联系人
+ (void)contractorDeleteRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:contractor_delete_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
//// 添加联系人
//+ (void)contractorAddRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
//    [[BaseNetworking shareInstance] startWithHeaderPostURL:contractor_add_api params:params success:^(id success) {
//        mainSuccess(success);
//    } failure:^(id failure) {
//        mainFailure(failure);
//    }];
//}
// 添加好友
+ (void)contractorAddRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:contact_add_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 模糊搜索
+ (void)searchContractorRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:search_contact_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 添加常用联系人
+ (void)concernContractorAddRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:concern_contractor_add_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 取消常用联系人
+ (void)concernContractorRemoveRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:concern_contractor_remove_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 常用联系人列表
+ (void)concernContractorListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:concern_contractor_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
    
}
// 企业通讯录列表
//+ (void)departmentListRequestParams:(NSDictionary *)params start:(NSString *)startString limit:(NSString *)limitString detail:(NSString *)detailString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
//    [[BaseNetworking shareInstance] startWithHeaderGetURL:department_list_api(startString,limitString,detailString) params:params success:^(id success) {
//        mainSuccess(success);
//    } failure:^(id failure) {
//        mainFailure(failure);
//    }];
//}
+ (void)departmentListRequestParams:(NSDictionary *)params detail:(NSString *)detailString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:department_list_api(detailString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 联系人和用户列表
+ (void)contractorAllListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:contractor_alllist_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}


// 创建讨论组
+ (void)createGroupRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:group_create_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 编辑用户组
+ (void)editGroupRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:group_edit_api(gidString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 删除用户组
+ (void)deleteGroupRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] requestDELETEDataWithUrl:group_delete_api(gidString) withParamters:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// append group members
+ (void)appendGroupRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:group_append_api(gidString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];

}
// 将用户移出用户组
+ (void)removeMemberGroupRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:group_remove_api(gidString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 用户组成员列表
+ (void)groupMemberListRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:group_member_list_api(gidString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];

}
// 用户组列表
+ (void)groupListRequestParams:(NSDictionary *)params kind:(NSString *)kindString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:group_list_api(kindString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}


// 可加入的用户组列表
+ (void)groupAvailableListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:group_available_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 已加入的用户组列表
+ (void)groupJointListRequestParams:(NSDictionary *)params kind:(NSString *)kindString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:group_joint_list_api(kindString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 加入用户组
+ (void)groupMemberJoinRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:group_member_join_api(gidString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 退出讨论组
+ (void)groupMemberQuitRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:group_member_quit_api(gidString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 添加常用用户组
+ (void)groupConcernJoinRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:group_concern_join_api(gidString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 取消常用用户组
+ (void)groupConcernRemoveRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:group_concern_remove_api(gidString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 常用用户组列表
+ (void)groupConcernListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:group_concern_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 上传通讯录内容
+ (void)adressbookListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:adressbook_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 获取通讯录的内容列表
+ (void)adressGetListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:adressbook_get_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 通讯录统计各个模块的人数
+ (void)adressbookListCountRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:adressbooklist_count_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

/**
 设备
 */
// 添加设备
+ (void)addDeviceRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:add_device_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 编辑设备
+ (void)editDeviceRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:edit_device_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 删除设备
+ (void)deleteDeviceRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:delete_device_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 设备列表
+ (void)deviceListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:list_device_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

/**
 支付
 */

// 微信支付
+ (void)getWechatPay:(NSDictionary *)params signid:(NSString *)signid success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    NSLog(@"pay_typepay_type%@",wechatPay_post_api(signid));
    [[BaseNetworking shareInstance] startWithHeaderPostURL:wechatPay_post_api(signid) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 微信支付 订单验证支付成功与否
+ (void)wechatPayResult:(NSDictionary *)params signid:(NSString *)signid success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:wechatPayResult_check_api(signid) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 请求栏目的计划 区分类型 视频的1
+ (void)requesetPlanChooseResult:(NSDictionary *)params signid:(NSString *)signid success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {

    [[BaseNetworking shareInstance] startWithHeaderGetURL:requestChoosenPlanResult_api(signid) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 我当前的计划 区分类型 视频的1
+ (void)requesetMyPlanChooseResult:(NSDictionary *)params signid:(NSString *)signid success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:requestMyChoosenPlan_api(signid) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 请求历史订单
+ (void)historypayOrderResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:historypay_order_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 展示微信支付
+ (void)showTheWechatResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:show_theWechat_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 用于是否进会
+ (void)canJoinTheMeetrequeset:(NSDictionary *)params  typeId:(NSString *)typeId signid:(NSString *)signid success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    NSLog(@"canjoinType%@",can_joinTheMeet_api(typeId,signid));
    [[BaseNetworking shareInstance] startWithHeaderGetURL:can_joinTheMeet_api(typeId,signid) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 购买了免费的计划
+ (void)buyTheFreeorderWechatResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:buyThe_Freeorder_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 我的钱包
+ (void)walletMineWechatResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:Wallet_Mine_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 我的钱包充值
+ (void)walletAddMineWechatResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:Wallet_AddMine_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 我的钱包充值确认
+ (void)walletConfireMineWechatResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:Wallet_ConfireMine_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 我的钱包充值金额list请求
+ (void)walletAmountListResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:Wallet_amountList_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 我的钱包余额
+ (void)walletmyWalletResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:Wallet_mywallet_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 我的钱包明细
+ (void)walletHistoryResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:Wallet_history_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 充值确定是立即开通还是充值界面
+ (void)walletDredgeTimePlanResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:wallet_dredgeTimePlan_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 关闭计时计划
+ (void)walletCloseTimePlanResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:wallet_closeTimePlan_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 关闭计时计划服务
+ (void)walletCloseTimeServiceResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:wallet_closeTimeService_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 免费计划详情介绍
+ (void)freeplanDetailResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:freeplan_detail_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 我的钱包充值下面的服务列表的list请求
+ (void)walletserverListResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:walletserver_List_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

/**
 新版本支付
 */
// 我的计划列表
+ (void)newPayPlanListResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:newPay_planlist_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 某个计划详情
+ (void)newPayPlanDetailResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:newPay_plandetail_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 我当前的计划
+ (void)newPayNowPlanResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:newPay_nowplan_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 计划和服务购买记录
+ (void)newPayPlanRecordResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:newPay_planrecord_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 扩展服务列表
+ (void)newPayServiceListResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:newPay_servicelist_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 某个服务的详情
+ (void)newPayServiceDetailResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:newPay_servicedetail_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 新微信支付
+ (void)newPayAppPayResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:newPay_appPay_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 新微信支付验证
+ (void)newPayPayVerifyResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:newPay_payVerify_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 我的当前服务列表
+ (void)serviceCurrentListResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:service_current_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
/**
 动态获取图片(首页和发现页的设备宣传图)
 */
// 首页
+ (void)firstPagePicturePay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:firstPage_Picture_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 发现
+ (void)findPagePicturePay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:findPage_Picture_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 发现列表
+ (void)findListPicturePay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:findlist_Picture_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

/**
 新版发现数据 广告和广告位
 */
// 广告
+ (void)advertiseSearchParams:(NSDictionary *)params user:(NSString *)userString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:advertise_search_api(userString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 广告位管理
+ (void)advertiseposilAllParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:advertiseposil_all_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 广告位以及广告整个列表  目前用的接口
+ (void)advertAllParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:advert_all_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 通过广告唯一id去查询广告详情
+ (void)advertSelectParams:(NSDictionary *)params aid:(NSString *)aidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:advert_select_api(aidString) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 发现页面广告轮播
+ (void)newFindPicturePay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:newFind_Picture_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

/**
 企业广场
 */
// 商铺套商品总列表 用于list展示
+ (void)companySquareListPay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:companySquare_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 搜索 商铺或者商品 get请求
+ (void)companySquareSearchParams:(NSDictionary *)params vague:(NSString *)vagueString dist:(NSString *)distString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:companySquare_search_api(vagueString, distString) params:params success:^(id success) {
        NSLog(@"companayaa %@",companySquare_search_api(vagueString, distString));
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 商铺总列表
+ (void)companyShopListPay:(NSDictionary *)params adid:(NSString *)adidStr success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:companyShop_list_api(adidStr) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 商品总列表
+ (void)companyGoodListPay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:companyGood_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
+ (void)goodListDetailPay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:goodlist_detail_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 提交表单 新用户申请加入
+ (void)submitContactPay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;{
    [[BaseNetworking shareInstance] startWithHeaderPostURL:submit_contact_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 管理助手
+ (void)manageAssisRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:manage_assis_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 视频营销客服
+ (void)saleVideomanageAssisRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure  {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:sale_video_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 上传营销的背景图片
+ (void)sendVMBackPicRequestParams:(NSDictionary *)params bodys:(BodysBlock)mainBodys progress:(ProgressBlock)mainProgress success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startPicWithHeaderPostURL:sendVM_backPic_api params:params bodys:^(id bodys) {
        mainBodys(bodys);
    } progress:^(id progress) {
        mainProgress(progress);
    } success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
    
}
// 发送反馈
+ (void)sendFeedBackRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:send_feedback_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 入会时候加入到群组IM
+ (void)addIMgroupMemberRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:add_IMgroup_member_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 会议文档列表
+ (void)confDocListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:confDoc_List_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 上传文档
+ (void)confDocUploadRequestParams:(NSDictionary *)params bodys:(BodysBlock)mainBodys progress:(ProgressBlock)mainProgress success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startPicWithHeaderPostURL:confDoc_upload_api params:params bodys:^(id bodys) {
//        NSLog(@"confDoc_upload_api %@",confDoc_upload_api);
        mainBodys(bodys);
    } progress:^(id progress) {
        mainProgress(progress);
    } success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 会议速记上传
+ (void)shorthandRecordRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:shorthand_record_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 会议速记列表
+ (void)shorthandListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:shorthand_detail_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 会议速记详细
+ (void)shorthandDetailRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:shorthand_detail_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 消息管理
+ (void)messageClassificationRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:message_classification_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 查询消息下的具体列表
+ (void)messageDetailListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:messageDetail_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
//
+ (void)hidePlanRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:hidePlan_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 苹果pay
+ (void)inappPayRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:inapppay_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 苹果pay列表
+ (void)inappPayListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:inapppayList_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 苹果pay服务列表
+ (void)servicelistforauditListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:servicelistforauditList_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 苹果pay生成预订单
+ (void)inappPayGetorderRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:inapppayGetorder_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 首页的跳转到查看消息
+ (void)homeMessageRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:homeMessage_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 首页的云空间列表
+ (void)cloudspaceClassRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:cloudspace_class_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 首页的云空间列表里面的详情列表
+ (void)cloudspaceDetailRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:cloudspace_detail_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 首页的教学模式列表
+ (void)classmodelListRequestParams:(NSDictionary *)params iconid:(NSString *)iconid success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:classmodel_list_api(iconid) params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 首页的教学模式列表里面的详情支付
+ (void)classmodelDetailpayRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:classmodel_detailpay_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 首页的教学模式列表里面支付
+ (void)classmodelgotopayRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:classmodel_gotopay_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 服务中心顶部栏目
+ (void)servicecenterSortlistRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:servicecenter_sortlist_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 服务中心列表
+ (void)servicecenterlistRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:servicecenter_centerlist_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 服务中心详情
+ (void)servicecenterinfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:servicecenter_centerinfo_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}

// 首页的图片列表
+ (void)mainpagePicRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderGetURL:mainpage_pic_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 同声传译列表
+ (void)interpreterListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:interpreterman_list_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 知识店铺列表
+ (void)commodityInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:commodity_info_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}
// 知识店铺购买
+ (void)priceServiceInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure {
    [[BaseNetworking shareInstance] startWithHeaderPostURL:price_service_info_api params:params success:^(id success) {
        mainSuccess(success);
    } failure:^(id failure) {
        mainFailure(failure);
    }];
}


+ (void)cancelAllRequest {
    [[BaseNetworking shareInstance] cancleAllRequest];
}

@end
