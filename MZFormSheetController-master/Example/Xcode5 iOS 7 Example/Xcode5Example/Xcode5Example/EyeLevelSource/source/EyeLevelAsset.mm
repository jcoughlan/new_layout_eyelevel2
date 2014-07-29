//
//  EyeLevelAsset.m
//  EyeLevel
//
//  Created by Apple on 16/11/2011.
//  Copyright (c) 2011 Fluid Pixel. All rights reserved.
//

#import "EyeLevelAsset.h"
#import "ZipFile.h"
#import "FileInZipInfo.h"
#import "ZipReadStream.h"
#import "XMLReader.h"
#import "CLLocationCoordinate2D+OSGB.h"

@interface EyeLevelAsset (Private)
+(NSDictionary*) loadManifestFromZip:(ZipFile*)zipFile;
+(NSString*) cacheObjFromZip:(ZipFile*)zipFile usingManifest:(NSDictionary*)manifest;
+(NSString*) cacheSurroundingObjFromZip:(ZipFile*)zipFile usingManifest:(NSDictionary*)manifest;
+(NSString*) cacheObjFromZip:(ZipFile *)zipFile withFilename:(NSString*)filename;
+(NSString*) cacheThumbnailFromZip:(ZipFile*)zipFile usingManifest:(NSDictionary*)manifest;
+(CLLocationCoordinate2D) readCoordinateFromManifest:(NSDictionary*) manifest;
+(NSString*) readModelNameFromManifest: (NSDictionary*) manifest;
@end

@implementation EyeLevelAsset
@synthesize coordinate;
@synthesize title;
@synthesize thumbnailPath;
@synthesize objPath;
@synthesize textureMapPath;
@synthesize surroundingOBJPath;
//@synthesize model;

-(id) initWithELVFile:(NSString*)elvFilePath
{
    self = [super init];
    
    if( self )
    {
		NSDate* before = [NSDate date];
		
        NSString* elvFilename = [elvFilePath lastPathComponent];
        NSLog(@"Initialising EyeLevelAsset - %@", elvFilename);
        
        ZipFile *unzipFile= [[ZipFile alloc] initWithFileName:elvFilePath mode:ZipFileModeUnzip];
        @try 
        {
            NSDictionary* manifestDict = [EyeLevelAsset loadManifestFromZip:unzipFile]; 
            
            self.title =                [EyeLevelAsset readModelNameFromManifest:manifestDict];
            
            self.surroundingOBJPath =   [EyeLevelAsset cacheSurroundingObjFromZip:unzipFile usingManifest:manifestDict];
           
            
            self.thumbnailPath =        [EyeLevelAsset cacheThumbnailFromZip:unzipFile usingManifest:manifestDict];
            self.textureMapPath =		@"red.png";
			
           //  self.objPath =              [EyeLevelAsset cacheObjFromZip:unzipFile usingManifest:manifestDict];
          
            
           // models = (GLModel**) malloc(sizeof ( GLModel*) * [[manifestDict retrieveForPath:@"Model"] count]);
            
            if([[manifestDict retrieveForPath:@"Model"] count] > 40)
            {
                [NSException raise:@"Too many models" format:@"%@", @"Due to memory limitations on your device, you may only have a maximum of 40 models per building."];
                return nil;
            }
            
            Boolean isNewModel;
            isNewModel = YES;
            modelCount = [[manifestDict retrieveForPath:@"Model"] count];
            for(int i = 0; i < [[manifestDict retrieveForPath:@"Model"] count]; ++i)
            {
                
                objectPath[i] = [EyeLevelAsset cacheObjFromZip:unzipFile usingManifest:[[[manifestDict retrieveForPath:@"Model"] objectAtIndex:i] retrieveForPath:@"file"]];

                GLModel* newModel = new GLModel(objectPath[i] , self.textureMapPath, Matrix4::IDENTITY, isNewModel );
                isNewModel = NO;
                models[i] = newModel;
            }
			
			surroundingModel = new GLModel(self.surroundingOBJPath, self.textureMapPath, Matrix4::IDENTITY, NO);
			
			CLLocationCoordinate2D_OSGB* coordinateConverter = [[CLLocationCoordinate2D_OSGB alloc] init];
			self.coordinate =  [coordinateConverter convertOSGB36toWGS84:[coordinateConverter OSGB36locationFromOSGB36Grid: Vector2(models[0]->getPosition().x, -models[0]->getPosition().z) ]];
			NSLog(@"model is at pos %f", models[0]-> getPosition().x);

			        
			NSLog(@"Time to load asset %@ - %f seconds", self.title, [[NSDate date] timeIntervalSinceDate: before]   );
        }
        @catch (NSException *exception) 
        {
            [NSException raise:exception.name format:@"%@ - %@", elvFilename, exception.description];
        }
    }
    return self;
}

-(int) getModelCount
{
    return modelCount;
}

-(Vector3) getVerticiesFor:(int)index modelNumber:(int)modNum
{
    return models[modNum]->m_cornerList[index];
}

-(int) getNumberOfcornersForModelNumber:(int)modNum
{
    return models[modNum]->numberOfCorners;
}

-( void ) dealloc
{
	
	//delete models[];
	delete surroundingModel;
	
}

#pragma mark - Public Methods
+(EyeLevelAsset*) eyeLevelAssetFromELVFile:(NSString*)elvFilePath
{
    return [[EyeLevelAsset alloc] initWithELVFile:elvFilePath];
}

#pragma mark - Private Methods
+(NSDictionary*) loadManifestFromZip:(ZipFile*)zipFile
{
    //each asset file must contain a manifest.xml - this file describes the remaining contents of the zip
    if( ![zipFile locateFileInZip:@"manifest.xml"] )
    {
        [NSException raise:@"Failed to process Manifest file" format:@"%@", @"Could not find manifest.xml"];
    }
    
    NSLog(@"    - Processing manifest.xml");
    
    ZipReadStream *inStream = [zipFile readCurrentFileInZip];
    
    //parse stream to xml data
    NSMutableData *xmlData = [[NSMutableData alloc] init];
    
    int bytesRead = 0;
    do
    {
        NSMutableData *xmlDataChunk= [[NSMutableData alloc] initWithLength:256];
        bytesRead = [inStream readDataWithBuffer:xmlDataChunk];
        [xmlDataChunk setLength:bytesRead];
        [xmlData appendData:xmlDataChunk];
    } 
    while (bytesRead != 0);
    
    NSError* error = nil;
    NSDictionary* xmlDict = [XMLReader dictionaryForXMLData:xmlData error:&error];
    
    
    if( error )
    {
        [NSException raise:@"Failed to process Manifest file" format:@"%@", [error localizedDescription]];
    }
    
    NSDictionary* manifestData = [xmlDict objectForKey:@"Manifest"];
    if( manifestData == nil )
    {
        [NSException raise:@"Failed to process Manifest file" format:@"%@", @"Manifest must contain a <Manifest></Manifest> Tag as the root element"];
    }
    
    
    return manifestData;
}

+(NSString*) cacheObjFromZip:(ZipFile *)zipFile withFilename:(NSString*)filename;
{
    if( ![zipFile locateFileInZip:filename] )
    {
        [NSException raise:@"Failed to process Manifest file" format:@"%@", [NSString stringWithFormat: @"Could not find %@", filename]];
    }
    
    ZipReadStream* inStream = [zipFile readCurrentFileInZip];
    
    //parse stream to xml data
    NSMutableData *fileData = [[NSMutableData alloc] init];
    
    int bytesRead = 0;
    do
    {
        NSMutableData *fileDataChunk= [[NSMutableData alloc] initWithLength:256];
        bytesRead = [inStream readDataWithBuffer:fileDataChunk];
        [fileDataChunk setLength:bytesRead];
        [fileData appendData:fileDataChunk];
    } 
    while (bytesRead != 0);
    
    
    //write data to cache, return path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];      
    NSString *destinationName = filename;
    NSString *destinationPath = [documentsDirectory stringByAppendingPathComponent:destinationName]; 
    
    
    BOOL writeSuccess = [fileData writeToURL:[NSURL fileURLWithPath:destinationPath] atomically:YES];
    
    if( !writeSuccess )
    {
        [NSException raise: @"Failed to load OBJ" format:@"Failed to write %@ to cache", filename];
    }
    
    return destinationPath;

}

+(NSString*) cacheObjFromZip:(ZipFile*)zipFile usingManifest:(NSString*)modelPath;
{    
    //process obj, for this we move the file to the cached directory and store the path.
    if( modelPath == nil )
    {
        [NSException raise:@"Failed to process Manifest file" format:@"%@",  @"Manifest must contain a <Model><file>{fileName}.obj</file></Model> Tag"];
    }
    
    return [self cacheObjFromZip:zipFile withFilename:modelPath];
    
}

+(NSString*) cacheSurroundingObjFromZip:(ZipFile*)zipFile usingManifest:(NSDictionary*)manifest;
{
    //process obj, for this we move the file to the cached directory and store the path.
    NSString* modelPath = [manifest objectForKey:@"Model_Surrounding"]; 
    if( modelPath == nil )
    {
        return nil;
    }
    
    return [self cacheObjFromZip:zipFile withFilename:modelPath];
}

+(CLLocationCoordinate2D) readCoordinateFromManifest:(NSDictionary*) manifest
{
    //check for positional data
    NSDictionary* locationDict = [manifest objectForKey:@"Location"];
    if ( locationDict == nil )
    {
        [NSException raise:@"Failed to process Manifest file" format:@"%@",  @"Manifest must contain a <Location></Location> Tag"];
    }
    
    if( [locationDict objectForKey:@"Latitude"] == nil || [locationDict objectForKey:@"Longitude"] == nil )
    {
        [NSException raise:@"Failed to process Manifest file" format:@"%@",  @"Manifest must contain a <Latitude>{value}</Latitude><Longitude>{value}<Longitude> Tag nested within hte Location Tag"];
    }
    
    double lat = [[locationDict objectForKey:@"Latitude"] doubleValue];
    double lon = [[locationDict objectForKey:@"Longitude"] doubleValue];
    NSLog(@"        - Processing Location %f lat %f lon", lat, lon);
    
	return CLLocationCoordinate2DMake(lat,lon);
}

+(NSString*) readModelNameFromManifest: (NSDictionary*) manifest
{
  
  
    //check for the model name in the manifest
    NSString* modelName = [manifest objectForKey:@"ModelName"]; 
    if( modelName == nil )
    {
        [NSException raise:@"Failed to process Manifest file" format:@"%@", @"Manifest must contain a <ModelName>{ModelName}</Model> Tag"];
    }
    
    NSLog(@"        - Processing Model %@", modelName );
    return modelName;
}

+(NSString*) cacheThumbnailFromZip:(ZipFile*)zipFile usingManifest:(NSDictionary*)manifest
{
    NSString* thumbnailName = [manifest objectForKey:@"Thumbnail"];
    if( thumbnailName != NULL )
    {
        NSLog(@"        - Processing Thumbnail %@", thumbnailName);
        //search for the file in the zip denoted by the thumbnail tag
        if( [zipFile locateFileInZip:thumbnailName] )
        {
            ZipReadStream *inStream = [zipFile readCurrentFileInZip];
            
            //parse stream to xml data
            NSMutableData *fileData = [[NSMutableData alloc] init];
            
            int bytesRead = 0;
            do
            {
                NSMutableData *fileDataChunk= [[NSMutableData alloc] initWithLength:256];
                bytesRead = [inStream readDataWithBuffer:fileDataChunk];
                [fileDataChunk setLength:bytesRead];
                [fileData appendData:fileDataChunk];
            } 
            while (bytesRead != 0);
            
            //write data to cache, return path
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];      
            NSString *destinationName = thumbnailName;
            NSString *destinationPath = [documentsDirectory stringByAppendingPathComponent:destinationName]; 
            
            BOOL writeSuccess = [fileData writeToURL:[NSURL fileURLWithPath:destinationPath] atomically:YES];
            
            if( !writeSuccess )
            {
                [NSException raise: @"Failed to load OBJ" format:@"Failed to write %@ to cache", thumbnailName];
            }
            
            return destinationPath;
                   
        }
        else
        {
            NSLog(@"           - Warning: manifest.xml declares Thumbnail %@ but it was not found within the archive", thumbnailName);
        }
    }
    
    return nil;
}

#pragma mark - Mutators
-(GLModel*) getModelForModelNum:(int)modelNum
{
	return models[modelNum];
}

-(GLModel*) getSurroundingModel
{
	return surroundingModel;
}
/*-(GLModel*) getModel
{
	return model;
}
    */
@end
