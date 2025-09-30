//
//  NotificationService.m
//  FirebaseNotificationServiceExtension
//
//  Created by InspireUI on 10/1/25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    // Find image URL from multiple possible locations
    NSString *imageUrlString = nil;

    // Check in userInfo[@"image"] (common location)
    if (request.content.userInfo[@"image"] != nil) {
        imageUrlString = request.content.userInfo[@"image"];
    }
    // Check in userInfo[@"fcm_options"][@"image"] (alternative location)
    else if (request.content.userInfo[@"fcm_options"] != nil &&
             [request.content.userInfo[@"fcm_options"] isKindOfClass:[NSDictionary class]] &&
             ((NSDictionary *)request.content.userInfo[@"fcm_options"])[@"image"] != nil) {
        imageUrlString = ((NSDictionary *)request.content.userInfo[@"fcm_options"])[@"image"];
    }
    // Check in userInfo[@"data"][@"image"] (another alternative location)
    else if (request.content.userInfo[@"data"] != nil &&
             [request.content.userInfo[@"data"] isKindOfClass:[NSDictionary class]] &&
             ((NSDictionary *)request.content.userInfo[@"data"])[@"image"] != nil) {
        imageUrlString = ((NSDictionary *)request.content.userInfo[@"data"])[@"image"];
    }
    // Check in userInfo[@"aps"][@"image"] (another alternative location)
    else if (request.content.userInfo[@"aps"] != nil &&
             [request.content.userInfo[@"aps"] isKindOfClass:[NSDictionary class]] &&
             ((NSDictionary *)request.content.userInfo[@"aps"])[@"image"] != nil) {
        imageUrlString = ((NSDictionary *)request.content.userInfo[@"aps"])[@"image"];
    }

    // Log the entire userInfo for debugging (can be removed in production)
    NSLog(@"Notification userInfo: %@", request.content.userInfo);

    // Check if image URL exists
    if (imageUrlString != nil && ![imageUrlString isEqualToString:@""]) {
        // Create URL from string
        NSURL *imageUrl = [NSURL URLWithString:imageUrlString];

        // Create session to download image
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

        // Create download task for image
        [[session dataTaskWithURL:imageUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // Check if there's an error or no data
            if (error != nil || data == nil) {
                // Return notification content without image
                self.contentHandler(self.bestAttemptContent);
                return;
            }

            // Create temporary file to store image
            NSString *fileExtension = [self getExtensionFromResponse:response defaultExtension:@"jpg"];
            NSString *fileName = [NSString stringWithFormat:@"%@.%@", [[NSUUID UUID] UUIDString], fileExtension];
            NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];

            // Write image data to file
            [data writeToURL:fileURL atomically:YES];

            // Create attachment from file URL
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:fileURL options:nil error:&error];

            // Check if attachment creation was successful
            if (attachment) {
                // Add attachment to notification content
                self.bestAttemptContent.attachments = @[attachment];
            }

            // Keep original title and body from notification
            // No need to reassign title and body as they were already copied from request.content

            // Return updated notification content
            self.contentHandler(self.bestAttemptContent);
        }] resume];
    } else {
        // If no image URL, return notification content immediately
        // Use original content already copied from request.content
        self.contentHandler(self.bestAttemptContent);
    }
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

// Method to get file extension from response
- (NSString *)getExtensionFromResponse:(NSURLResponse *)response defaultExtension:(NSString *)defaultExtension {
    NSString *suggestedExtension = defaultExtension;

    // Get Content-Type from response
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSString *contentType = httpResponse.allHeaderFields[@"Content-Type"];

        // Determine extension based on Content-Type
        if (contentType) {
            if ([contentType containsString:@"image/jpeg"]) {
                suggestedExtension = @"jpg";
            } else if ([contentType containsString:@"image/png"]) {
                suggestedExtension = @"png";
            } else if ([contentType containsString:@"image/gif"]) {
                suggestedExtension = @"gif";
            } else if ([contentType containsString:@"image/webp"]) {
                suggestedExtension = @"webp";
            }
        }
    }

    return suggestedExtension;
}

@end
