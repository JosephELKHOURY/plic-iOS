#import "CCMenuAdvanced.h"
#import "UnitListLayer.h"

enum nodeTags
{
	kBackButtonMenu,
	kWidget,
    kWidgetReversed
};

@implementation UnitListLayer

@synthesize unitList;

- (id) init
{
	if ( (self = [super init]) )
	{
		// Create back button menu item.
        CCMenuItem *backMenuItem =
            [CCMenuItemImage itemWithNormalImage:@"back.png"
                                   selectedImage:@"backSel.png"
                                          target:self
                                        selector: @selector(backPressed)
             ];
        
		CCMenuAdvanced *menu = [CCMenuAdvanced menuWithItems:backMenuItem, nil];
        
        menu.priority = kCCMenuHandlerPriority - 1;
        
		[self addChild:menu z:0 tag: kBackButtonMenu];
	}
	
	return self;
}

- (void) refreshForUnitList:(NSMutableArray *)playerUnitList
{
    [self removeChild:widget cleanup:YES];
    [self removeChild:widgetReversed cleanup:YES];
    
    self.unitList = playerUnitList;
    
    // Create vertical scroll widget.
    widget = [self widget];
    [self addChild: widget z: 0 tag: kWidget];
    
    // Create vertical reversed scroll widget.
    widgetReversed = [self widgetReversed];
    if (widgetReversed)
        [self addChild: widgetReversed z: 0 tag: kWidgetReversed];
    
    // Do initial layout.
    [self updateForScreenReshape];
}


- (void) updateForScreenReshape
{
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	// Position back button at the top-left corner.
	CCMenuAdvanced *menu = (CCMenuAdvanced *)[self getChildByTag: kBackButtonMenu];
	menu.anchorPoint = ccp(0, 1);
	menu.position = ccp(0, s.height);
	
	[self updateWidget];
}

// Go back to the default ExtensionTest Layer.
- (void) backPressed
{
	[[CCDirector sharedDirector] popScene];
}

#pragma mark Vertical Scroll Widget

- (CCNode *) widget
{	
	// Prepare Menu
	CCMenuAdvanced *menu = [CCMenuAdvanced menuWithItems: nil];
    for (Unit *unit in self.unitList) {
        CCMenuItem *unitItem = [CCMenuItemImage itemWithNormalImage:unit.imgRight
                                                      selectedImage:unit.imgBack
                                                             target:self
                                                           selector:@selector(itemPressed:)];
        [menu addChild:unitItem];
    }
    
    [menu alignItemsVerticallyWithPadding: 5 bottomToTop: NO];
    menu.ignoreAnchorPointForPosition = NO;
	
	return menu;
}

- (CCNode *) widgetReversed
{
    CCMenuAdvanced *menu = [CCMenuAdvanced menuWithItems: nil];
    for (Unit *unit in unitList) {
        CCMenuItem *unitItem = [CCMenuItemImage itemWithNormalImage:unit.imgRight
                                                      selectedImage:unit.imgBack
                                                             target:self
                                                           selector:@selector(itemPressed:)];
        [menu addChild:unitItem];
    }
	
	// Setup Menu Alignment
	[menu alignItemsVerticallyWithPadding: 5 bottomToTop: YES];
    menu.ignoreAnchorPointForPosition = NO;
	
	return menu;
}

- (void) updateWidget
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
    // Menu at the Left.
    {
        CCMenuAdvanced *menu = (CCMenuAdvanced *) [self getChildByTag:kWidget];
        
        //widget
        menu.anchorPoint = ccp(0.5f, 1);
        menu.position = ccp(winSize.width / 4, winSize.height);
        
        menu.scale = MIN ((winSize.width / 2.0f) / menu.contentSize.width, 0.75f );
        
        menu.boundaryRect = CGRectMake(MAX(0, winSize.width / 4.0f - [menu boundingBox].size.width / 2.0f),
                                       25.0f,
                                       [menu boundingBox].size.width,
                                       winSize.height - 50.0f );
        
        [menu fixPosition];
    }
    
    // Reversed Menu at the Rigth.
    {
        CCMenuAdvanced *menu2 = (CCMenuAdvanced *) [self getChildByTag:kWidgetReversed];
        
        //widget
        menu2.anchorPoint = ccp(0.5f, 1);
        menu2.position = ccp( 0.75f * winSize.width / 4, winSize.height);
        
        menu2.scale = MIN ((winSize.width / 2.0f) / menu2.contentSize.width, 0.75f );
        
        menu2.boundaryRect = CGRectMake(MIN(winSize.width, 0.75 * winSize.width - [menu2 boundingBox].size.width / 2.0f),
                                        25.0f,
                                        [menu2 boundingBox].size.width,
                                        winSize.height - 50.0f );
        
        [menu2 fixPosition];
    }
}

- (void) itemPressed: (CCNode *) sender
{
	NSLog(@"CCMenuAdvancedVerticalTestLayer#itemPressed: %@", sender);
}

@end