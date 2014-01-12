//
//  MusicModel.h
//  MusicPlayer2
//
//  Created by abujj on 14-1-8.
//  Copyright (c) 2014年 abujj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
{
    NSString *name;
    NSString *type;
}

@property (retain,nonatomic)NSString *name;

@property (retain,nonatomic)NSString *type;

-(id) initWithName:(NSString *)_name andType:(NSString *)_type;

@end
