//
//  main.m
//  icnsmake
//
//  Created by Alex Zielenski on 4/8/12.
//  Copyright (c) 2012 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IconFamily.h"
#include <getopt.h>

static NSString *stringFromCString(char *cString) {
	if (cString == NULL)
		return nil;
	
	return [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
}

static NSBitmapImageRep *imageRepWithPath(char *path) {
	if (path == NULL)
		return nil;
	
	NSBitmapImageRep *rep = [[[NSBitmapImageRep alloc] initWithData:[NSData dataWithContentsOfFile:stringFromCString(path)]] autorelease];
	
	return rep;
}

static void showUsage(void) {
	printf("Usage:\n\t-c [ --1024 path ] [ --512 path ] [ --256 path ] [ --128 path ] [ --48 path ] | [ --32 path ] [ --16 path ] --output pathToIcns\n\t-e inputicns [ --1024 path ] [ --512 path ] [ --256 path ] [ --128 path ] [ --48 path ] | [ --32 path ] [ --16 path ] [ --output pathToExportFolder ]");
}

int main(int argc, const char * argv[])
{
	if (argc < 4) {
		showUsage();
		return 0;
	}
	
	@autoreleasepool {		
		int c;
	    int option_index = 0;
        static struct option long_options[] = {
            {"1024",   required_argument, 0,  0 },
            {"512",    required_argument, 0,  0 },
            {"256",    required_argument, 0,  0 },
            {"128",    required_argument, 0,  0 },
            {"48",     required_argument, 0,  0 },
            {"32",     required_argument, 0,  0 },
			{"16",     required_argument, 0,  0 },
			{"output", required_argument, 0,  0 },
            {0,        0,                 0,  0 }};
		
		char *p1024  = NULL;
		char *p512   = NULL;
		char *p256   = NULL;
		char *p128   = NULL;
		char *p48    = NULL;
		char *p32    = NULL;
		char *p16    = NULL;
		
		char *input  = NULL;
		char *output = NULL;
		
		Boolean create  = NO;
		Boolean export  = NO;
		
		while ((c = getopt_long(argc, (char *const*)argv, "ce:", long_options, &option_index)) != -1) {
			switch (c) {
				case 0: {
					switch (option_index) {
						case 0: // --1024
							p1024 = optarg;
							break;
						case 1: // --512
							p512 = optarg;
							break;
						case 2: // --256
							p256 = optarg;
							break;
						case 3: // --128
							p128 = optarg;
							break;
						case 4: // --48
							p48 = optarg;
							break;
						case 5: // --32
							p32 = optarg;
							break;
						case 6: // --16
							p16 = optarg;
							break;
						case 7: // --output
							output = optarg;
							break;
						default:
							break;
					}
					break;
				} case 'c':
					create = true;
					export = false;
					break;
				case 'e':
					create = false;
					export = true;
					input  = optarg;
					break;
				default:
					printf ("Uknown option %o\n", c);
					break;
			}
		}
		
		if (!create && !export) {
			showUsage();
			return 0;
		}
		
		if (export && !input) {
			showUsage();
			return 0;
		}
		
		if (create) {
			IconFamily *icon = [IconFamily iconFamily];
			
			[icon setIconFamilyElement:kIconServices1024PixelDataARGB fromBitmapImageRep:imageRepWithPath(p1024)];
			[icon setIconFamilyElement:kIconServices512PixelDataARGB fromBitmapImageRep:imageRepWithPath(p512)];
			[icon setIconFamilyElement:kIconServices256PixelDataARGB fromBitmapImageRep:imageRepWithPath(p256)];
			[icon setIconFamilyElement:kIconServices128PixelDataARGB fromBitmapImageRep:imageRepWithPath(p128)];
			[icon setIconFamilyElement:kIconServices48PixelDataARGB fromBitmapImageRep:imageRepWithPath(p48)];
			[icon setIconFamilyElement:kIconServices32PixelDataARGB fromBitmapImageRep:imageRepWithPath(p32)];
			[icon setIconFamilyElement:kIconServices16PixelDataARGB fromBitmapImageRep:imageRepWithPath(p16)];
			
			NSString *outputPath = stringFromCString(output);
			
			// Create parent directory
			[[NSFileManager defaultManager] createDirectoryAtPath:[outputPath stringByDeletingLastPathComponent]
									  withIntermediateDirectories:YES 
													   attributes:nil 
															error:nil];
			
			[icon writeToFile:outputPath];
			
		} else if (export) {
			IconFamily *icon = [IconFamily iconFamilyWithContentsOfFile:stringFromCString(input)];
			NSString *outputFolder = stringFromCString(output);
			
			[[NSFileManager defaultManager] createDirectoryAtPath:outputFolder 
									  withIntermediateDirectories:YES 
													   attributes:nil 
															error:NO];
			
			// Export 1024
			if (p1024 != NULL || output != NULL) {
				NSBitmapImageRep *i1024 = [icon bitmapImageRepWithAlphaForIconFamilyElement:kIconServices1024PixelDataARGB];
				NSData *d1024 = [i1024 representationUsingType:NSPNGFileType properties:nil];
				
				if (p1024 != NULL)
					[d1024 writeToFile:stringFromCString(p1024) atomically:NO];
				
				[d1024 writeToFile:[outputFolder stringByAppendingPathComponent:@"1024.png"] atomically:NO];
				
			}
			
			// Export 512
			if (p512 != NULL || output != NULL) {
				NSBitmapImageRep *i512 = [icon bitmapImageRepWithAlphaForIconFamilyElement:kIconServices512PixelDataARGB];
				NSData *d512 = [i512 representationUsingType:NSPNGFileType properties:nil];
				
				if (p512 != NULL)
					[d512 writeToFile:stringFromCString(p512) atomically:NO];
				
				[d512 writeToFile:[outputFolder stringByAppendingPathComponent:@"512.png"] atomically:NO];
				
			}
			
			// Export 256
			if (p256 != NULL || output != NULL) {
				NSBitmapImageRep *i256 = [icon bitmapImageRepWithAlphaForIconFamilyElement:kIconServices256PixelDataARGB];
				NSData *d256 = [i256 representationUsingType:NSPNGFileType properties:nil];
				
				if (p256 != NULL)
					[d256 writeToFile:stringFromCString(p256) atomically:NO];
				
				[d256 writeToFile:[outputFolder stringByAppendingPathComponent:@"256.png"] atomically:NO];
				
			}
			
			// Export 128
			if (p128 != NULL || output != NULL) {
				NSBitmapImageRep *i128 = [icon bitmapImageRepWithAlphaForIconFamilyElement:kIconServices128PixelDataARGB];
				NSData *d128 = [i128 representationUsingType:NSPNGFileType properties:nil];
				
				if (p128 != NULL)
					[d128 writeToFile:stringFromCString(p128) atomically:NO];
				
				[d128 writeToFile:[outputFolder stringByAppendingPathComponent:@"128.png"] atomically:NO];
				
			}
			
			// Export 48
			if (p48 != NULL || output != NULL) {
				NSBitmapImageRep *i48 = [icon bitmapImageRepWithAlphaForIconFamilyElement:kIconServices48PixelDataARGB];
				NSData *d48 = [i48 representationUsingType:NSPNGFileType properties:nil];
				
				if (p48 != NULL)
					[d48 writeToFile:stringFromCString(p48) atomically:NO];
				
				[d48 writeToFile:[outputFolder stringByAppendingPathComponent:@"48.png"] atomically:NO];
				
			}
			
			// Export 32
			if (p32 != NULL || output != NULL) {
				NSBitmapImageRep *i32 = [icon bitmapImageRepWithAlphaForIconFamilyElement:kIconServices32PixelDataARGB];
				NSData *d32 = [i32 representationUsingType:NSPNGFileType properties:nil];
				
				if (p32 != NULL)
					[d32 writeToFile:stringFromCString(p32) atomically:NO];
				
				[d32 writeToFile:[outputFolder stringByAppendingPathComponent:@"32.png"] atomically:NO];
				
			}
			
			// Export 16
			if (p16 != NULL || output != NULL) {
				NSBitmapImageRep *i16 = [icon bitmapImageRepWithAlphaForIconFamilyElement:kIconServices16PixelDataARGB];
				NSData *d16 = [i16 representationUsingType:NSPNGFileType properties:nil];
				
				if (p16 != NULL)
					[d16 writeToFile:stringFromCString(p16) atomically:NO];
				
				[d16 writeToFile:[outputFolder stringByAppendingPathComponent:@"16.png"] atomically:NO];
				
			}
		}
		
	};
	
    return 0;
}

