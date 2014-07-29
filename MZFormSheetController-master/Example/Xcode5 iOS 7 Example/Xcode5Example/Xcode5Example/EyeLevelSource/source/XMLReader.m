//
//  XMLReader.m
//  PocketTours
//
//  Created by Jamie Stewart on 26/05/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

#import "XMLReader.h"
#import "NSString+HTML.h"

NSString *const kXMLReaderTextNodeKey = @"_content_";

@interface XMLReader (Internal)

- (id)initWithError:(NSError **)error;
- (NSDictionary *)objectWithData:(NSData *)data;

@end

@implementation NSDictionary (XMLReaderNavigation)

- (id)retrieveForPath:(NSString *)navPath
{
	//NSLog(@"navPath: %@", navPath);
	
	// Split path on dots
 	NSArray *pathItems = [navPath componentsSeparatedByString:@"."];
 	// Enumerate through array
 	NSEnumerator *e = [pathItems objectEnumerator];
 	NSString *path;
 	// Set first branch from self
 	id branch = [self objectForKey:[e nextObject]];
 	int count = 1;
 	
	while ((path = [e nextObject]))
	{
		// Check if this branch is an NSArray
		if([branch isKindOfClass:[NSArray class]])
		{
			if ([path isEqualToString:@"last"])
			{
				branch = [branch lastObject];
			}
			else
			{
				if ([branch count] > [path intValue])
				{
					branch = [branch objectAtIndex:[path intValue]];
				}
				else
				{
					branch = nil;
				}
			}
		}
		else
		{
			// branch is assumed to be an NSDictionary
			if (![branch isKindOfClass:[NSDictionary class]])
			{
				NSError* error;
				branch = [XMLReader dictionaryForXMLString:branch error:&error];
			}
			branch = [branch objectForKey:path];
		}
		count++;
	}
 	return branch;
}

@end

@implementation XMLReader

//\===============================================================================================================
//\ Accessors to generate a Dictioinary from XML Data
//\===============================================================================================================
+(NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)error
{
    XMLReader* reader               = [[XMLReader alloc] initWithError:error];
    NSDictionary* rootDictionary    = [reader objectWithData:data];
    return rootDictionary;
}

+(NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)error
{
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XMLReader dictionaryForXMLData:data error:error];
}
//\===============================================================================================================
//\ Constructor
//\===============================================================================================================
-(id)initWithError:(NSError **)error
{
    if ( (self = [super init]) )
    {
       // errorPointer = error;
    }
    return self;
}
//\===============================================================================================================
//\ Destructor
//\===============================================================================================================
//\===============================================================================================================
//\
//\===============================================================================================================
-(NSDictionary *)objectWithData:(NSData *)data
{
    // Clear out any old data
    
    m_dictionaryStack   = [[NSMutableArray alloc] init];
    m_textInProgress    = [[NSMutableString alloc] init];
    
    // Initialize the stack with a fresh dictionary
    [m_dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    // Parse the XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    // Return the stack’s root dictionary on success
	NSDictionary* resultDict = nil;
    if ([parser parse])
    {
        resultDict = [m_dictionaryStack objectAtIndex:0];
    }
    return resultDict;
}

//\===============================================================================================================
//\ NSXMLParserDelegate methods
//\===============================================================================================================
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict
{
    // Get the dictionary for the current level in the stack
    NSMutableDictionary* parentDict = [m_dictionaryStack lastObject];
    // Create the child dictionary for the new element, and initilaize it with the attributes
    NSMutableDictionary* childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    // If there’s already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    if( existingValue )
    {
        NSMutableArray *array = nil;
        if( [existingValue isKindOfClass:[NSMutableArray class]] )
        {
            // The array exists, so use it
            array = (NSMutableArray *) existingValue;
        }
        else
        {
            // Create an array if it doesn’t exist
            array = [NSMutableArray array];
            [array addObject:existingValue];
            
            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        }
        
        // Add the new child dictionary to the array
        [array addObject:childDict];
    }
    else
    {
        // No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];
    }
    
    // Update the stack
    [m_dictionaryStack addObject:childDict];
}

//\===============================================================================================================
//\ NSXMLParserDelegate Callback: Called when an XML element is ended
//\===============================================================================================================
-(void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
{
    // Update the parent dict with text info
    NSMutableDictionary* dictInProgress = [m_dictionaryStack lastObject];
    // Set the text property
    if ([m_textInProgress length] > 0)
    {
        if( [dictInProgress count] == 0 )
        {
            [m_dictionaryStack removeLastObject];
            dictInProgress = [m_dictionaryStack lastObject];
            id existingValue = [dictInProgress objectForKey:elementName];
            if( existingValue && [existingValue isKindOfClass:[NSMutableArray class]] )
            {
                // The array exists, so use it
                [(NSMutableArray*)existingValue addObject:[NSDictionary dictionaryWithObject:m_textInProgress forKey:elementName]];
            }
            else
            {
                [dictInProgress setObject:m_textInProgress forKey:elementName];
            }
        }
        else
        {
            // Get rid of leading + trailing whitespace
           [dictInProgress setObject:m_textInProgress forKey:elementName];
            [m_dictionaryStack removeLastObject];
        }
        // Reset the text
        m_textInProgress = [[NSMutableString alloc] init];
    }
    else
    {
        [m_dictionaryStack removeLastObject];
    }
    // Pop the current dict
    int size = [dictInProgress count];
    if( size <= 0 )
    {
        // If there was no value for the tag, and no attribute, then remove
        // it from the dictionary.
        NSMutableDictionary *parentDict = [m_dictionaryStack lastObject];
        
        id value = [parentDict objectForKey:elementName];
        if( ![value isKindOfClass:[NSMutableArray class]] )
        {
            [parentDict removeObjectForKey:elementName];
        }
        else
        {
            if( [value count] > 0 )
            {
                [(NSMutableArray*)value removeLastObject];
            }
        }
    }
}


//\===============================================================================================================
//\ NSXMLParser Delegate to construct the content of an xml element
//\===============================================================================================================
-(void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string
{
	[m_textInProgress appendString:string];
	
	NSString *trimmedString = [m_textInProgress stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	[m_textInProgress setString:trimmedString];
}


//\===============================================================================================================
//\ An Error occurred Set the error pointer to the parser’s error object
//\===============================================================================================================
-(void)parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError
{
    //*errorPointer = parseError;
}

@end