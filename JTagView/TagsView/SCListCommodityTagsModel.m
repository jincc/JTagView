//
//  SCListCommodityTagsModel.m
//  JuMei
//
//  Created by junlongj on 16/1/26.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "SCListCommodityTagsModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SCCommodityTagsView.h"
@implementation SCListCommodityTagsModel

-(instancetype)init{
    self = [super init];
    if (self) {
        self.tagDataSourcStyle = SCTagDataSourcStyleBrand;
        self.tagsDisplayStyle = SCCommodityTagsViewShowStyleAllRight;
        self.leftProportion = 0.5f;
        self.TopProportion = 0.5f;
        self.superviewSize = CGSizeMake(kMainScreenWidth, kMainScreenWidth);
    }
    return self;
}
-(CGPoint)tagViewTouchPoint{
    CGFloat x = self.superviewSize.width * self.leftProportion;
    CGFloat y = self.superviewSize.height * self.TopProportion;
    return  CGPointMake(ceil(x), ceil(y));
}

-(NSArray<NSString *> *)transformToTagsViewData{
    
    if (self.tagDataSourcStyle == SCTagDataSourcStyleBrand) {
        NSString *brandName = stringWithObject(self.brandName );
        if (brandName.length) {
            brandName = [brandName stringByAppendingString:@" "];
        }
        brandName  = [brandName stringByAppendingString:stringWithObject(self.tradeName)];
        
        NSString *address = stringWithObject(self.country );
        if (address.length) {
            address = [address stringByAppendingString:@" "];
        }
        address  = [address stringByAppendingString:stringWithObject(self.detailsAddtress)];
        
        
        NSString *price =  stringWithObject(self.currency);
        if (price.length) {
            price = [price stringByAppendingString:@" "];
        }
        price = [price stringByAppendingString:stringWithObject(self.price)];
        return @[brandName,
                 price,
                 address];
    }else{
        
        NSString *des = stringWithObject(self.commonTagTextDes);
        if (des.length) {
            des = [des stringByAppendingString:@" "];
        }
        return @[@"",
                 des,
                 @""];
    }

}

-(NSDictionary *)transformToJson{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    [json setObject:@(self.tagDataSourcStyle) forKey:@"type"];
    [json setObject:@(self.leftProportion) forKey:@"left"];
    [json setObject:@(self.TopProportion) forKey:@"top"];
    [json setObject:@(self.tagsDisplayStyle) forKey:@"layout"];
    
    void(^SafeAddObject)(NSString *, NSString *) = ^(NSString *value, NSString *key ) {
        if (value.length) {
            [json setObject:value forKey:key];
        }
    };
    
    SafeAddObject(self.commonTagId,@"label_id");
    SafeAddObject(self.commonTagTextDes,@"label_name");
    SafeAddObject(self.brandId , @"brand_id");
    SafeAddObject(self.brandName , @"brand_name");
    SafeAddObject(self.tradeId , @"product_id");
    SafeAddObject(self.tradeName , @"product_name");
    SafeAddObject(self.currencyId , @"currency_id");
    SafeAddObject(self.detailsAddtress , @"address");
    SafeAddObject(self.countryId , @"country_id");
    SafeAddObject(self.price,@"price");
 
    return json;
    
}



-(BOOL)isEqual:(SCListCommodityTagsModel *)object{
    if ([self.commonTagTextDes isEqualToString:object.commonTagTextDes]&&
        [self.brandName isEqualToString:object.brandName]&&
        [self.tradeName isEqualToString:object.tradeName]&&
        [self.currency isEqualToString:object.currency]&&
        [self.price isEqualToString:object.price]&&
        [self.country isEqualToString:object.country]&&
        [self.detailsAddtress isEqualToString:self.detailsAddtress]) {
        return true;
    }
    
    return false;
}
NSString *stringWithObject(id object) {

    if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return [object stringValue];
    } else {
        return @"";
    }
}


@end

