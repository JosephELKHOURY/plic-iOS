//
//  FacebookShareViewController.h
//  PLIC-iOS
//
//  Created by Joseph El Khoury on 9/5/12.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookShareViewController : UIViewController
- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)shareButtonAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *postMessageTextView;
@property (strong, nonatomic) IBOutlet UIImageView *postImageView;
@property (strong, nonatomic) IBOutlet UILabel *postNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *postDescriptionLabel;
@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;

@end
