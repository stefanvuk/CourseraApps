//
//  GameViewController.m
//  BreakOut
//
//  Created by Stefan on 2/27/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

// pola koda iskomentarisano jer su imbecili i dalje na ios 9 u videima.....

#import "GameViewController.h"
#import "GameScene.h"
#import "GameStart.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
    // including entities and graphs.
    //GKScene *scene = [GKScene sceneWithFileNamed:@"GameScene"];
    
    // Get the SKScene from the loaded GKScene
    //GameScene *sceneNode = (GameScene *)scene.rootNode;
    
    // Copy gameplay related content over to the scene
    //sceneNode.entities = [scene.entities mutableCopy];
    //sceneNode.graphs = [scene.graphs mutableCopy];
    
    // Set the scale mode to scale to fit the window
    // sceneNode.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // sprite kit applies additional optimizations to improve rendering performance
    skView.ignoresSiblingOrder = YES;
    
    // create and configure the scene
    GameStart *scene = [GameStart nodeWithFileNamed:@"GameStart"];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    // Present the scene
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
