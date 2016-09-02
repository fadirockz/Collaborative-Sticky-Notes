//
//  CollaborativeNoteUITests.m
//  CollaborativeNoteUITests
//
//  Created by Fahad on 24/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CollaborativeNoteUITests : XCTestCase

@end

@implementation CollaborativeNoteUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAdd {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.navigationBars[@"Notes"].buttons[@"Add"] tap];
    XCUIElement *subjectTextField = app.textFields[@"Subject"];
    [subjectTextField tap];
    [subjectTextField typeText:@"Fahad"];
    [app.navigationBars[@"Create Note"].buttons[@"Save"] tap];
    
}

- (void)testConnect {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.toolbars.buttons[@"Connect"] tap];
    [app.buttons[@"Seach Peers"] tap];
    [app.tables.staticTexts[@"iPhone"] tap];
    [app.navigationBars.buttons[@"Done"] tap];
    
}

- (void)testShare {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.tables.staticTexts[@"Fahad"] tap];
    [app.toolbars.buttons[@"Share"] tap];
    
    XCUIElement *okButton = app.alerts[@"Share Note"].collectionViews.buttons[@"OK"];
    [okButton tap];
    
}
- (void)testDelete {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"Christmas"] swipeLeft];
    [tablesQuery.buttons[@"Delete"] tap];
    
}
- (void) testSearch{
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [[app.tables containingType:XCUIElementTypeSearchField identifier:@"Search"].element swipeDown];
    [app.tables.searchFields[@"Search"] tap];
    [app.searchFields[@"Search"] typeText:@"fahad"];
    [app.buttons[@"Search"] tap];
    
}
- (void) testEditNote{
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.tables.staticTexts[@"Fahad"] tap];
    
    XCUIElement *subjectTextField = app.textFields[@"Subject"];
    [subjectTextField tap];
    
    XCUIElement *deleteKey = app.keys[@"delete"];
    [deleteKey tap];
    [deleteKey tap];
    [subjectTextField typeText:@"zulfiqar"];
    
    XCUIElement *textView = [[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"Edit Note"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeTextView].element;
    [textView tap];
    [app.buttons[@"shift"] tap];
    [textView typeText:@"Fahad"];
    [app.navigationBars[@"Edit Note"].buttons[@"Save"] tap];
    
}
- (void) testSearchPeers
{
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationFaceUp;
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.toolbars.buttons[@"Connect"] tap];
    [app.buttons[@"Seach Peers"] tap];
    [app.navigationBars.buttons[@"Cancel"] tap];
    
}

- (void) testVisibility{
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.toolbars.buttons[@"Connect"] tap];
    [[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"ConnectPeersView"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element tap];
    [app.switches[@"1"] tap];
    [app.switches[@"0"] tap];
    [[[[app.navigationBars[@"ConnectPeersView"] childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Back"] elementBoundByIndex:0] tap];
    
}
@end