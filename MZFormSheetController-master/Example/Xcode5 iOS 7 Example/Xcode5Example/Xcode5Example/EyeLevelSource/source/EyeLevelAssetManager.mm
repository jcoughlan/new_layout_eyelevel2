//
//  FileManager.m
//  EyeLevel
//
//  Created by Apple on 15/11/2011.
//  Copyright (c) 2011 Fluid Pixel. All rights reserved.
//

#import "EyeLevelAssetManager.h"

//Used for proper thread safe singleton
#import <libkern/OSAtomic.h>


#import "CLLocationCoordinate2D+OSGB.h"
//Zip Archive
#import "XMLReader.h"

@interface EyeLevelAssetManager (Private)
-(NSArray*) getAssetPaths;
@end

@implementation EyeLevelAssetManager
@synthesize delegate;

static EyeLevelAssetManager* sharedInstance = nil;                                                

#pragma mark - Singleton
+ (id)sharedInstance {
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedInstance] retain];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}


- (id)init {
    if (self = [super init]) {

    }
    return self;
}

-(void) dealloc
{
    if( assets )
        [assets release], assets = nil;
    
    [super dealloc];
}

-(NSArray*) getAssetPaths
{
    NSMutableArray *retval = [NSMutableArray array];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *publicDocumentsDir = [paths objectAtIndex:0];   
    
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:publicDocumentsDir error:&error];
    if (files == nil)
    {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    for (NSString *file in files) 
    {
        if ([file.pathExtension compare:kCustomBundleExtension options:NSCaseInsensitiveSearch] == NSOrderedSame) 
        {        
            NSString *fullPath = [publicDocumentsDir stringByAppendingPathComponent:file];
            [retval addObject:fullPath];
        }
    }

    
    return retval;
}

-(void) loadAssets
{
    if( assets == nil )
    {
        NSArray* assetPaths = [self getAssetPaths];
        
        assets = [[NSMutableArray alloc] init];
        
        for( NSString* path in assetPaths )
        {
            @try 
            {
                EyeLevelAsset* asset = [[EyeLevelAsset alloc] initWithELVFile:path];
                
                [assets addObject:asset];
                
                if( delegate )
                    [delegate onAssetLoaded:asset];
                
                CLLocationCoordinate2D_OSGB* coordinateConverter = [[CLLocationCoordinate2D_OSGB alloc] init];
                
                
                for(int i = 0; i < [asset getNumberOfcornersForModelNumber:0]; ++i)
                {
                    NSLog(@"loading point %i", i);
                    EyeLevelAsset* pointMarker = [[EyeLevelAsset alloc] init];
                    
                    Vector3 pointVert = [asset getVerticiesFor:i modelNumber:0];
                    
                   [pointMarker setCoordinate:[coordinateConverter convertOSGB36toWGS84:[coordinateConverter OSGB36locationFromOSGB36Grid: Vector2(pointVert.x, -pointVert.z) ]]];
                    [pointMarker setTitle:@"corner"];
                    if( delegate )
                        [delegate onAssetLoaded:pointMarker];
                    
                }
                [coordinateConverter release];
                
                
            }
            @catch (NSException *exception) 
            {
                [[[[UIAlertView alloc] initWithTitle:exception.name message:exception.description delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] autorelease] show];
            }
        }
    }  
}

-(NSArray*) getAssets;
{
    if( assets == nil ) 
    {
        [self loadAssets];
    }
    
    return assets;
}



-(BOOL) importAssetFromURL:(NSURL*)url
{
    if( [url.lastPathComponent.pathExtension isEqualToString:kCustomBundleExtension] )
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];      
        NSString *destinationName = url.lastPathComponent;
        NSString *destinationPath = [documentsDirectory stringByAppendingPathComponent:destinationName];

        int i = 0;
        while( [[NSFileManager defaultManager] fileExistsAtPath:destinationPath] )
            {
            NSString* newFileName = [NSString stringWithFormat:@"%@%i%@", url.lastPathComponent.stringByDeletingPathExtension, i++, url.pathExtension];
            destinationPath = [documentsDirectory stringByAppendingPathComponent:newFileName];
        }
        
        NSError* error = nil;
        
        [[NSFileManager defaultManager] copyItemAtURL:url toURL:[NSURL fileURLWithPath:destinationPath ] error:&error];
        
        if( error )
        {
            return NO;
        }
        
        EyeLevelAsset* asset = nil;
        @try 
        {
            asset = [[EyeLevelAsset alloc] initWithELVFile:destinationPath];
        }
        @catch (NSException *exception) 
        {
            [[[[UIAlertView alloc] initWithTitle:exception.name message:exception.description delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] autorelease] show];
            return NO;
        }

        [assets addObject:asset];
        
        if( delegate )
            [delegate onAssetLoaded:asset];
    }
    else
    {
        return NO;
    }

    return YES;
}
@end
