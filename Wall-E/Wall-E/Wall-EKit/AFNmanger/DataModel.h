//
//  DataModel.h
//  YLY11_10
//
//  Created by 严林燕 on 14/11/10.
//  Copyright (c) 2014年 严林燕. All rights reserved.
//

#import "JSONModel.h"

@interface DataModel : JSONModel

@end


//网络返回的状态的详细信息
@interface BaseModel : DataModel

@property (assign, nonatomic) NSInteger State;
@property (strong, nonatomic) NSString *Message;
@property (strong, nonatomic) NSObject<ConvertOnDemand> *Data;

@end



