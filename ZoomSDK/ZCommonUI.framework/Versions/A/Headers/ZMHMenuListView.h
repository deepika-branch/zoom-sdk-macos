//
//  ZMHMenuListView.h
//  zChatUI
//
//  Created by Huxley on 2018/3/31.
//  Copyright © 2018 Zipow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ZMHMenuItem;
@protocol ZMHMenuListViewDelegate;
@interface ZMHMenuListView : NSView
{
    NSTrackingArea *_trackingArea;
    BOOL _mouseInside;
    ZMHMenuItem *_currentItem;
}

@property (retain, readonly) NSTableView *tableView;

@property (assign) id <ZMHMenuListViewDelegate> mouseEventDelegate;
@property (retain, nonatomic) NSArray <ZMHMenuItem *> *menuItemList;
@property (readonly) BOOL mouseInside;
@property (nonatomic) NSEdgeInsets paddings;

@property (readonly) ZMHMenuItem *selectedItem;

@end

@protocol ZMHMenuListViewDelegate <NSObject>

- (void)listViewSelectionDidChange:(ZMHMenuListView *)listView hovered:(BOOL)hovered;

- (BOOL)shouldListViewDeselectCurrentItem:(ZMHMenuListView *)listView;
- (void)mouseExistListView:(ZMHMenuListView *)listView;

@end