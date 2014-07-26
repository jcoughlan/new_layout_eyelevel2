//
//  XMLReader.h
//  PocketTours
//
//  Created by Jamie Stewart on 26/05/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLReader : NSObject <NSXMLParserDelegate>
{
    NSMutableArray*         m_dictionaryStack;
    NSMutableString*        m_textInProgress;
    NSMutableArray*         m_elementStack;
    NSString*               m_currentElement;
    
    
    NSError **errorPointer;
}

+(NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+(NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;

@end

@interface NSDictionary (XMLReaderNavigation)
- (id)retrieveForPath:(NSString *)navPath;
@end