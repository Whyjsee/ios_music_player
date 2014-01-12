//
//  MusicModel.m
//  MusicPlayer2
//
//  Created by abujj on 14-1-8.
//  Copyright (c) 2014年 abujj. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

@synthesize name,type;

-(id) initWithName:(NSString *)_name andType:(NSString *)_type
{
    if (self==[super init]) {
        self.name = _name;
        self.type=_type;
    }
    return self;
}


@end
