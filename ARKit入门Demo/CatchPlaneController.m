//
//  CatchPlaneController.m
//  ARKit入门Demo
//
//  Created by user on 2017/9/25.
//  Copyright © 2017年 陈泽槟. All rights reserved.
//

#import "CatchPlaneController.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>
// 这个类主要用到的是SceneKit
@interface CatchPlaneController () <ARSCNViewDelegate,ARSessionDelegate>

@property (nonatomic, strong) ARSCNView *arscnView;
@property (nonatomic, strong) ARSession *arSession;
@property (nonatomic, strong) ARWorldTrackingConfiguration *arConfig;

@end

@implementation CatchPlaneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view addSubview:self.arscnView];
    [self.arSession runWithConfiguration:self.arConfig];
    self.arscnView.debugOptions = ARSCNDebugOptionShowFeaturePoints;

    
}

#pragma mark - ARSCNViewDelegate
- (void)renderer:(id<SCNSceneRenderer>)renderer
      didAddNode:(SCNNode *)node
       forAnchor:(ARAnchor *)anchor {
    
    NSLog(@"ARSCNViewDelegate--捕捉到平面");
    //1.获取捕捉到的平地锚点
    ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
    //2.创建一个3D物体模型    （系统捕捉到的平地是一个不规则大小的长方形，这里笔者将其变成一个长方形，并且是否对平地做了一个缩放效果）
    //参数分别是长宽高和圆角
    SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x height:0 length:planeAnchor.extent.x chamferRadius:0];
    //3.使用Material渲染3D模型（默认模型是白色的，这里笔者改成红色）
    plane.firstMaterial.diffuse.contents = [UIColor redColor];
    
    //4.创建一个基于3D物体模型的节点
    SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
    //5.设置节点的位置为捕捉到的平地的锚点的中心位置  SceneKit框架中节点的位置position是一个基于3D坐标系的矢量坐标SCNVector3Make
    planeNode.position =SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
    
    //self.planeNode = planeNode;
    [node addChildNode:planeNode];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //1.创建一个花瓶场景
        SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/cup/cup.scn"];
        //2.获取花瓶节点（一个场景会有多个节点，此处我们只写，花瓶节点则默认是场景子节点的第一个）
        //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点
        SCNNode *vaseNode = scene.rootNode.childNodes[0];
        
        //4.设置花瓶节点的位置为捕捉到的平地的位置，如果不设置，则默认为原点位置，也就是相机位置
        vaseNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        
        //5.将花瓶节点添加到当前屏幕中
        //!!!此处一定要注意：花瓶节点是添加到代理捕捉到的节点中，而不是AR试图的根节点。因为捕捉到的平地锚点是一个本地坐标系，而不是世界坐标系
        [node addChildNode:vaseNode];
    });
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"ARSCNViewDelegate--刷新中");
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"ARSCNViewDelegate--节点更新");
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"ARSCNViewDelegate--节点移除");
}

#pragma mark - ARSessionDelegate
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
//    NSLog(@"移动相机");
}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor *> *)anchors
{
    NSLog(@"ARSessionDelegate--添加锚点");
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors
{
    
    NSLog(@"ARSessionDelegate--刷新锚点");
    
}

- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"ARSessionDelegate--移除锚点");
    
}



#pragma mark - getter
- (ARSCNView *)arscnView {
    if (!_arscnView) {
        _arscnView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        _arscnView.session = self.arSession;
        _arscnView.delegate = self;
        _arscnView.showsStatistics = YES; // 是否显示性能统计
        _arscnView.autoenablesDefaultLighting = YES; // 是否添加灯光到场景中，默认是NO
    }
    return _arscnView;

}

- (ARSession *)arSession {
    if (!_arSession) {
        _arSession = [[ARSession alloc] init];
        _arSession.delegate = self;
    }
    return _arSession;
}

- (ARWorldTrackingConfiguration *)arConfig {
    if (!_arConfig) {
        _arConfig = [[ARWorldTrackingConfiguration alloc] init];
        _arConfig.planeDetection = ARPlaneDetectionHorizontal;
    }
    return _arConfig;
}

@end
