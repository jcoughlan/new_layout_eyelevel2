//
//  FileManager.h
//  EyeLevel
//
//  Created by Apple on 15/11/2011.
//  Copyright (c) 2011 Fluid Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EyeLevelAsset.h"

#define kCustomBundleExtension @"elv"

@protocol EyeLevelAssetManagerDelegate;

@interface EyeLevelAssetManager : NSObject
{
    NSMutableArray* assets;
}
@property( nonatomic, assign ) IBOutlet id<EyeLevelAssetManagerDelegate> delegate;

+ (EyeLevelAssetManager *) sharedInstance;

-(BOOL) importAssetFromURL:(NSURL*)url;
-(void) loadAssets;
-(NSArray*) getAssets;
@end


@protocol EyeLevelAssetManagerDelegate <NSObject>
-(void) onAssetLoaded:(EyeLevelAsset*)asset;
@end