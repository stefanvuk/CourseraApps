//
//  GameScene.m
//  SpirteContainer
//
//  Created by Stefan on 3/19/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import "GameScene.h"


static const uint32_t category_fence   =  0x1 << 3;
static const uint32_t category_ball    =  0x1 << 0;

@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic, strong, nullable) UITouch *motivatingTouch;

@end

@implementation GameScene

- (void)sceneDidLoad {

    
    self.name = @"Fence";
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = category_fence;
    self.physicsBody.collisionBitMask = 0x0;
    self.physicsBody.contactTestBitMask = 0x0;
    self.physicsWorld.contactDelegate = self;
    
    SKSpriteNode *background = (SKSpriteNode *)[self childNodeWithName:@"Background"];
    background.zPosition = 0;
    
    SKSpriteNode *ball1 = [SKSpriteNode spriteNodeWithImageNamed:@"blueball-1.png"];
    ball1.name = @"Ball1";
    ball1.zPosition = 1.0;
    ball1.position = CGPointMake(-500, 370); // bilo je 100, self.size.height/2 sada je 60, 30
    
    ball1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball1.size.width/2];
    ball1.physicsBody.dynamic = YES;
    ball1.physicsBody.friction = 0.0;
    ball1.physicsBody.restitution = 1.0;
    ball1.physicsBody.linearDamping = 0.5;
    ball1.physicsBody.angularDamping = 0.5;
    ball1.physicsBody.allowsRotation = NO;
    ball1.physicsBody.mass = 5.0;
    ball1.physicsBody.velocity = CGVectorMake(200.0, 200.0); // initial velocity
    ball1.physicsBody.affectedByGravity = YES;
    ball1.physicsBody.categoryBitMask = category_ball;
    ball1.physicsBody.collisionBitMask = category_fence | category_ball;
    ball1.physicsBody.contactTestBitMask = category_fence;
    ball1.physicsBody.usesPreciseCollisionDetection = YES;

    
    SKSpriteNode *ball2 = [SKSpriteNode spriteNodeWithImageNamed:@"blueball-1.png"];
    ball2.name = @"Ball2";
    ball2.zPosition = 1.0;
    ball2.position = CGPointMake(80, 75); // bilo je 100, self.size.height/2 sada je 60, 30
    
    ball2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball2.size.width/2];
    ball2.physicsBody.dynamic = YES;
    ball2.physicsBody.friction = 0.0;
    ball2.physicsBody.restitution = 1.0;
    ball2.physicsBody.linearDamping = 0.0;
    ball2.physicsBody.angularDamping = 0.0;
    ball2.physicsBody.allowsRotation = NO;
    ball2.physicsBody.mass = 1.0;
    ball2.physicsBody.velocity = CGVectorMake(150.0, 150.0); // initial velocity
    ball2.physicsBody.affectedByGravity = NO;
    ball2.physicsBody.categoryBitMask = category_ball;
    ball2.physicsBody.collisionBitMask = category_fence | category_ball;
    ball2.physicsBody.contactTestBitMask = category_fence;
    ball2.physicsBody.usesPreciseCollisionDetection = YES;

    
    [self addChild:ball1];
    [self addChild:ball2];
    
}


- (void)touchDownAtPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    n.strokeColor = [SKColor greenColor];
//    [self addChild:n];
}

- (void)touchMovedToPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    n.strokeColor = [SKColor blueColor];
//    [self addChild:n];
}

- (void)touchUpAtPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    n.strokeColor = [SKColor redColor];
//    [self addChild:n];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    const CGRect touchesRegion = CGRectMake(-512, -384, self.size.width, self.size.height);
    
    for(UITouch *touch in touches){
        CGPoint p = [touch locationInNode:self];
        if(CGRectContainsPoint(touchesRegion, p)){
            self.motivatingTouch = touch;
            
            SKSpriteNode *ball1 = [SKSpriteNode spriteNodeWithImageNamed:@"blueball-1.png"];
            ball1.name = @"Ball1";
            ball1.zPosition = 1.0;
            ball1.position = CGPointMake(p.x, p.y);
            
            ball1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball1.size.width/2];
            ball1.physicsBody.dynamic = YES;
            ball1.physicsBody.friction = 0.0;
            ball1.physicsBody.restitution = 1.0;
            ball1.physicsBody.linearDamping = 0.0;
            ball1.physicsBody.angularDamping = 0.0;
            ball1.physicsBody.allowsRotation = NO;
            ball1.physicsBody.mass = 1.0;
            ball1.physicsBody.velocity = CGVectorMake(200.0, 200.0); // initial velocity
            ball1.physicsBody.affectedByGravity = NO;
            ball1.physicsBody.categoryBitMask = category_ball;
            ball1.physicsBody.collisionBitMask = category_fence | category_ball;
            ball1.physicsBody.contactTestBitMask = category_fence;
            ball1.physicsBody.usesPreciseCollisionDetection = YES;
            
            [self addChild:ball1];
        }
    }
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([touches containsObject:self.motivatingTouch])
        self.motivatingTouch = nil;
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if([touches containsObject:self.motivatingTouch])
        self.motivatingTouch = nil;}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered

    
    
    static const int kMaxSpeed = 1500;
    static const int kMinSpeed = 400;
    
    // Adjust the linear damping if the ball starts moving a little too fast or slow
    SKNode *ball1 = [self childNodeWithName:@"Ball1"];
    SKNode *ball2 = [self childNodeWithName:@"Ball2"];
    
    float dx = (ball1.physicsBody.velocity.dx + ball2.physicsBody.velocity.dx)/2;
    float dy = (ball1.physicsBody.velocity.dy + ball2.physicsBody.velocity.dy)/2;
    float speed = sqrt(dx*dx + dy*dy);
    if(speed > kMaxSpeed){
        ball1.physicsBody.linearDamping += 0.1f;
        ball2.physicsBody.linearDamping += 0.1f;
        //ball2.physicsBody.velocity = CGVectorMake(ball2.physicsBody.velocity.dx * .9, ball2.physicsBody.velocity.dy * .9);
    } else if (speed < kMinSpeed){
        ball1.physicsBody.linearDamping -= 0.1f;
        ball2.physicsBody.linearDamping -= 0.1f;
        //ball2.physicsBody.velocity = CGVectorMake(ball2.physicsBody.velocity.dx * 1.1, ball2.physicsBody.velocity.dy * 1.1);
    } else{
        ball1.physicsBody.linearDamping = 0.0f;
        ball2.physicsBody.linearDamping = 0.0f;
    }
    NSLog(@"ball1 %f %f", ball1.position.x, ball1.position.y);
}

@end
