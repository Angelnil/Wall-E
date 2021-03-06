//
//  AFNManager.h
//  Wall-E
//
//  Created by Angle_Yan on 15/5/19.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>



@interface AFNmanger : NSObject

#pragma mark - block定义

typedef void (^RequestSuccessed)(id responseObject);
typedef void (^RequestFailure)(NSInteger errorCode, NSString *errorMessage);

typedef NS_ENUM (NSInteger, RequestType) {
    RequestTypeGET = 0,
    RequestTypePOST,
    RequestTypeUploadFile,
    RequestTypePostBodyData
};


#pragma mark - 最常用的GET和POST

+ (void)requestDataFromUrl:(NSString *)url
                   WithAPI:(NSString *)apiName
               requestType:(RequestType)requestType
             andArrayParam:(NSArray *)arrayParam
              andDictParam:(NSDictionary *)dictParam
                 dataModel:(NSString *)modelName
              andBodyParam:(NSString *)bodyParam
          requestSuccessed:(RequestSuccessed)requestSuccessed
            requestFailure:(RequestFailure)requestFailure;


#pragma mark - 上传文件

//+ (void)uploadImage:(UIImage *)image
//              toUrl:(NSString *)url
//            withApi:(NSString *)apiName
//      andArrayParam:(NSArray *)arrayParam
//       andDictParam:(NSDictionary *)dictParam
//          dataModel:(NSString *)modelName
//       imageQuality:(ImageQuality)quality
//   requestSuccessed:(RequestSuccessed)requestSuccessed
//     requestFailure:(RequestFailure)requestFailure;


#pragma mark - 通用的GET和POST（只返回BaseModel的Data内容）

+ (void)requestByUrl:(NSString *)url
             withAPI:(NSString *)apiName
       andArrayParam:(NSArray *)arrayParam
        andDictParam:(NSDictionary *)dictParam
        andBodyParam:(NSString *)bodyParam
           dataModel:(NSString *)modelName
         requestType:(RequestType)requestType
    requestSuccessed:(RequestSuccessed)requestSuccessed
      requestFailure:(RequestFailure)requestFailure;


#pragma mark - 通用的GET、POST和上传图片（返回BaseModel的所有内容）

+ (void)requestByUrl:(NSString *)url
             withAPI:(NSString *)apiName
       andArrayParam:(NSArray *)arrayParam
        andDictParam:(NSDictionary *)dictParam
        andBodyParam:(NSString *)bodyParam
           imageData:(NSData *)imageData
         requestType:(RequestType)requestType
    requestSuccessed:(RequestSuccessed)requestSuccessed
      requestFailure:(RequestFailure)requestFailure;

@end
