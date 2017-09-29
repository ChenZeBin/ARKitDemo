//
//  ChairViewController.m
//  ARKit入门Demo
//
//  Created by user on 2017/9/29.
//  Copyright © 2017年 陈泽槟. All rights reserved.
//

#import "PlanetController.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

@interface PlanetController () <ARSessionDelegate, ARSCNViewDelegate>

//AR视图：展示3D界面
@property(nonatomic, strong) ARSCNView *arSCNView;

//AR会话，负责管理相机追踪配置及3D相机坐标
@property(nonatomic, strong) ARSession *arSession;

//会话追踪配置：负责追踪相机的运动
@property(nonatomic, strong) ARWorldTrackingConfiguration *arSessionConfiguration;

//飞机3D模型(本小节加载多个模型)
@property(nonatomic, strong) SCNNode *planeNode;

// 星球
@property(nonatomic, strong) SCNNode *sunNode;
@property(nonatomic, strong) SCNNode *earthNode;
@property(nonatomic, strong) SCNNode *moonNode;


@end

@implementation PlanetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //1.将AR视图添加到当前视图
    [self.view addSubview:self.arSCNView];
    //2.开启AR会话（此时相机开始工作）
    [self.arSession runWithConfiguration:self.arSessionConfiguration];
    [self addNode];
}

- (void)addNode {
    // 添加太阳
    [self.arSCNView.scene.rootNode addChildNode:self.sunNode]; // 添加到视图中
    [self.sunNode addChildNode:self.earthNode];
    [self.earthNode addChildNode:self.moonNode];

}





#pragma mark -搭建ARKit环境
//懒加载会话追踪配置
- (ARWorldTrackingConfiguration *)arSessionConfiguration
{
    if (_arSessionConfiguration != nil) {
        return _arSessionConfiguration;
    }
    
    //1.创建世界追踪会话配置（使用ARWorldTrackingSessionConfiguration效果更加好），需要A9芯片支持
    ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc] init];
    //2.设置追踪方向（追踪平面，后面会用到）
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    _arSessionConfiguration = configuration;
    //3.自适应灯光（相机从暗到强光快速过渡效果会平缓一些）
    _arSessionConfiguration.lightEstimationEnabled = YES;
    
    return _arSessionConfiguration;
    
}

//懒加载拍摄会话
- (ARSession *)arSession
{
    if(_arSession != nil)
    {
        return _arSession;
    }
    //1.创建会话
    _arSession = [[ARSession alloc] init];
    //2返回会话
    return _arSession;
}

//创建AR视图
- (ARSCNView *)arSCNView
{
    if (_arSCNView != nil) {
        return _arSCNView;
    }
    //1.创建AR视图
    _arSCNView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
    //2.设置视图会话
    _arSCNView.session = self.arSession;
    //3.自动刷新灯光（3D游戏用到，此处可忽略）
    _arSCNView.automaticallyUpdatesLighting = YES;
    
    return _arSCNView;
}


- (SCNNode *)sunNode {
    if (!_sunNode) {
        SCNNode *tempNode = [[SCNNode alloc] init];
        tempNode.geometry = [SCNSphere sphereWithRadius:5]; // 创建一个球体，半径是34.0
        tempNode.position = SCNVector3Make(0, 0, -100); // 设置位置
        tempNode.geometry.firstMaterial.multiply.contents = @"Models.scnassets/earth/sun.jpg"; // 把这个图片贴到照片上 比较淡
        tempNode.geometry.firstMaterial.diffuse.contents = @"Models.scnassets/earth/sun.jpg";
        tempNode.geometry.firstMaterial.multiply.intensity = 0.1; // 贴上的照片的效果，1->0 颜色逐渐变浅
        tempNode.geometry.firstMaterial.shininess = 1.0; // 目前我的理解是这个模型的发光
        tempNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // 照明模式
        tempNode.geometry.firstMaterial.multiply.wrapS =
        tempNode.geometry.firstMaterial.diffuse.wrapS  =
        tempNode.geometry.firstMaterial.multiply.wrapT =
        tempNode.geometry.firstMaterial.diffuse.wrapT  = SCNWrapModeRepeat;
        tempNode.geometry.firstMaterial.locksAmbientWithDiffuse   = YES;
        [tempNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
        _sunNode = tempNode;
    }
    return _sunNode;
}

- (SCNNode *)earthNode {
    if (!_earthNode) {
        SCNNode *tempNode = [[SCNNode alloc] init];
        tempNode.geometry = [SCNSphere sphereWithRadius:5]; // 创建一个球体，半径是34.0
        tempNode.position = SCNVector3Make(0, 0, -10); // 设置位置
        tempNode.geometry.firstMaterial.multiply.contents = @"Models.scnassets/earth/earth-diffuse-mini.jpg"; // 把这个图片贴到照片上 比较淡
        tempNode.geometry.firstMaterial.diffuse.contents = @"Models.scnassets/earth/earth-diffuse-mini.jpg";
        tempNode.geometry.firstMaterial.multiply.intensity = 0.1; // 贴上的照片的效果，1->0 颜色逐渐变浅
        tempNode.geometry.firstMaterial.shininess = 1.0; // 目前我的理解是这个模型的发光
        tempNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // 照明模式
        tempNode.geometry.firstMaterial.multiply.wrapS =
        tempNode.geometry.firstMaterial.diffuse.wrapS  =
        tempNode.geometry.firstMaterial.multiply.wrapT =
        tempNode.geometry.firstMaterial.diffuse.wrapT  = SCNWrapModeRepeat;
        tempNode.geometry.firstMaterial.locksAmbientWithDiffuse   = YES;
        [tempNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:2 y:0 z:0 duration:1]]];
        _earthNode = tempNode;
    }
    return _earthNode;
}

- (SCNNode *)moonNode {
    if (!_moonNode) {
        SCNNode *tempNode = [[SCNNode alloc] init];
        tempNode.geometry = [SCNSphere sphereWithRadius:5]; // 创建一个球体，半径是34.0
        tempNode.position = SCNVector3Make(0, 0, -10); // 设置位置
        tempNode.geometry.firstMaterial.multiply.contents = @"Models.scnassets/earth/moon.jpg"; // 把这个图片贴到照片上 比较淡
        tempNode.geometry.firstMaterial.diffuse.contents = @"Models.scnassets/earth/moon.jpg";
        tempNode.geometry.firstMaterial.multiply.intensity = 0.1; // 贴上的照片的效果，1->0 颜色逐渐变浅
        tempNode.geometry.firstMaterial.shininess = 1.0; // 目前我的理解是这个模型的发光
        tempNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // 照明模式
        tempNode.geometry.firstMaterial.multiply.wrapS =
        tempNode.geometry.firstMaterial.diffuse.wrapS  =
        tempNode.geometry.firstMaterial.multiply.wrapT =
        tempNode.geometry.firstMaterial.diffuse.wrapT  = SCNWrapModeRepeat;
        tempNode.geometry.firstMaterial.locksAmbientWithDiffuse   = YES;
        [tempNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:2 y:0 z:0 duration:1]]];
        _moonNode = tempNode;
    }
    return _moonNode;
}



@end

