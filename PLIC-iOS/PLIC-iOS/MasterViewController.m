//
//  MasterViewController.m
//  Parisk
//
//  Created by SEKIMIA on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "ARKit/ContentManager.h"
#import "cocos2d.h"
#import "MapScene.h"

@implementation MasterViewController
@synthesize rest;


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rest = [RestKitController getInstance];
    self.rest.masterDelegate = self;
    [self.rest setupMappingAndRoutes];
    [self getPlayerFromServer];
 	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)getPlayerFromServer
{
    player = [[Player alloc] createPlayer:1];
    //TODO GET FROM SERVER
    player.id = 1;
    [self.rest getArmiesOfPlayer:player.id];
}

- (void)setPlayer
{
    for (Player *p in self.rest.armies)
    {
        player.Warrior = p.Warrior;
        player.Knight = p.Knight;
        player.Boomerang = p.Boomerang;
    }
    NSLog(@"Warriors: %d", player.Warrior);
    NSLog(@"setPlayer: Done");
}

-(IBAction)goJeu
{
    /*GameViewController *v = [[GameViewController alloc] initWithNibName:@"GameView" bundle:nil];
    [self.navigationController pushViewController:v animated:YES];*/
    CCGLView *glView = [CCGLView viewWithFrame:self.view.bounds
								   pixelFormat:kEAGLColorFormatRGB565];
    [self.view insertSubview:glView atIndex:10];
    [[CCDirector sharedDirector] setView:glView];
    [[CCDirector sharedDirector] runWithScene:[Map scene:player]];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
