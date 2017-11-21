//
//  BBSARViewController.m
//  NxhTest
//
//  Created by apple on 2017/9/27.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSARViewController.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

@interface BBSARViewController ()<ARSCNViewDelegate>
//2D使用ARSKViewDelegate

@property (nonatomic,strong)ARSCNView * sceneView;
//2D使用
//@property (nonatomic, strong)ARSKView *sceneView;

@end

@implementation BBSARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置代理
    self.sceneView.delegate = self;
    
    // Show statistics such as fps and timing information
    //ARKit统计信息
    self.sceneView.showsStatistics = YES;
    
    // Create a new scene
    //使用模型创建节点（scn格式文件是一个基于3D建模的文件，使用3DMax软件可以创建，这里系统有一个默认的3D飞机）
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    //加载2D场景（2D是平面的）
//    Scene *scene = (Scene *)[SKScene nodeWithFileNamed:@"Scene"];
    
    // Set the scene to the view
    //设置ARKit的场景为SceneKit的当前场景（SCNScene是Scenekit中的场景，类似于UIView）
    self.sceneView.scene = scene;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //创建一个追踪设备配置（ARWorldTrackingSessionConfiguration主要负责传感器追踪手机的移动和旋转）
//    ARWorldTrackingSessionConfiguration *configuration = [ARWorldTrackingSessionConfiguration new];
//
//    // Run the view's session
//    // 开始启动ARSession会话（启动AR）
//    [self.sceneView.session runWithConfiguration:configuration];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    // 暂停ARSession会话
    [self.sceneView.session pause];
}

//2D使用
#pragma mark - ARSKViewDelegate
//点击界面会调用，类似于touch begin方法  anchor是2D坐标的瞄点
//- (SKNode *)view:(ARSKView *)view nodeForAnchor:(ARAnchor *)anchor {
//    // Create and configure a node for the anchor added to the view's session.
//    
//    //创建节点（节点可以理解为AR将要展示的2D图像）
//    SKLabelNode *labelNode = [SKLabelNode labelNodeWithText:@"2333"];
//}

#pragma mark - ARSCNViewDelegate
- (void)renderer:(id)renderer didAddNode:(SCNNode*)node forAnchor:(ARAnchor*)anchor{
    
    ARPlaneAnchor * planeAnchor = anchor;
    
    SCNPlane * plane = [SCNPlane planeWithWidth:planeAnchor.extent.x height:planeAnchor.extent.z];
    
    SCNNode * planeNode = [SCNNode nodeWithGeometry:plane];
    
    planeNode.position = SCNVector3Make(planeAnchor.center.x,0, planeAnchor.center.z);
    
    planeNode.transform = SCNMatrix4MakeRotation(-M_PI/2,1,0,0);
    
    [node addChildNode:planeNode];
    
}

@end
