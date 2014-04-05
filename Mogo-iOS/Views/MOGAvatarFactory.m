//
//  MOGAvatarFactory.h
//  Mogo-iOS
//
//  Created by Jurre Stender on 30/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGAvatarFactory.h"
#import "JSAvatarImageFactory.h"
#import "NSString+Hashtel.h"

static const CGFloat MOGAvatarLabelSize = 150.0f;
static const CGFloat MOGAvatarSize = 200.0f;

@implementation MOGAvatarFactory

+ (UIImageView *)avatarForUsername:(NSString *)username {
    UIView *avatarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MOGAvatarSize, MOGAvatarSize)];
    avatarView.backgroundColor = username.color;

    NSString *initial = [[username substringToIndex:1] uppercaseString];

    CGFloat centerX = MOGAvatarLabelSize - (avatarView.frame.size.width / 2);
    UILabel *initialLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX, 0, MOGAvatarLabelSize, MOGAvatarSize)];
    initialLabel.font = [UIFont systemFontOfSize:150];
    initialLabel.textColor = [UIColor whiteColor];
    initialLabel.text = initial;

    [avatarView addSubview:initialLabel];

    UIGraphicsBeginImageContextWithOptions(avatarView.bounds.size, avatarView.opaque, 0.0);
    [avatarView.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *avatarImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return [[UIImageView alloc] initWithImage:[JSAvatarImageFactory avatarImage:avatarImage croppedToCircle:YES]];
}

@end
