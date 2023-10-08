//
//  SwiftUIBuild.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/18/23.
//

import SwiftUI
import SpriteKit
import Combine

@available(macOS 10.15, *)
public struct Build: View {
    public var body: some View {
        let o = RootScene.init(size: CGSize.init(width: 1600, height: 1000))
        o.scaleMode = .aspectFit
        if #available(macOS 11.0, *) {
            //return SpriteView.init(scene: o)
            return SpriteKitSceneView.init()
            //return SpriteViewWithOverlay.init(spriteViewModel: SpriteViewModel(scene: o))
        } else {
            // Fallback on earlier versions
            fatalError("Upgrade to MacOS 11 for the SpriteView object")
        }
    }
    public init(_ n: Scene) {
        currentScene = n
    }
}

var totalNodes = 0
struct SpriteKitSceneView: NSViewRepresentable {
    func makeNSView(context: Context) -> SKView {
        let skView = SKView()
        let scene = RootScene.init(size: CGSize.init(width: 1600, height: 1000))
        scene.scaleMode = .aspectFit
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        
        setFrameRateVisibility = {
            skView.showsFPS = $0
        }
        setNodeCountVisibility = {
            skView.showsNodeCount = $0
        }
        setPhysicsVisibility = {
            skView.showsPhysics = $0
        }
        
        skView.presentScene(scene)
        return skView
    }

    func updateNSView(_ nsView: SKView, context: Context) {
        // Update if needed
    }
}


var setFrameRateVisibility: (Bool) -> () = { _ in }
var setNodeCountVisibility: (Bool) -> () = { _ in }
var setPhysicsVisibility: (Bool) -> () = { _ in }

//
//struct SpriteViewWithOverlay: View {
//    @ObservedObject var spriteViewModel: SpriteViewModel
//
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            SpriteView(scene: spriteViewModel.scene)
//                .ignoresSafeArea()
//
//            // Overlay View with information
//            VStack(alignment: .leading, spacing: 10) {
//
//                if spriteViewModel.isFrameRateCountVisible {
//                    Text("FPS: \(spriteViewModel.currentFrameRate/10).\(spriteViewModel.currentFrameRate%10)")
//                        .foregroundColor(.white)
//                        .padding(5)
//                        .background(SwiftUI.Color.black.opacity(0.5))
//                        .cornerRadius(5)
//                        .onAppear {
//                            spriteViewModel.startUpdatingFrameRate()
//                        }
//                        .onDisappear {
//                            spriteViewModel.stopUpdatingFrameRate()
//                        }
//                        .gesture(TapGesture(count: 2).onEnded {
//                            spriteViewModel.toggleFrameRateCountVisibility()
//                        })
//                }
//
//                if spriteViewModel.isNodeCountVisible {
//                    Text("Node Count: \(spriteViewModel.nodeCount)")
//                        .foregroundColor(.white)
//                        .padding(5)
//                        .background(SwiftUI.Color.black.opacity(0.5))
//                        .cornerRadius(5)
//                        .onAppear {
//                            spriteViewModel.startUpdatingNodeCount()
//                        }
//                        .onDisappear {
//                            spriteViewModel.stopUpdatingNodeCount()
//                        }
//                        .gesture(TapGesture(count: 2).onEnded {
//                            spriteViewModel.toggleNodeCountVisibility()
//                        })
//                }
//            }
//            .padding(10)
//
//        }
//    }
//}
//
//
//var totalNodes = 0
//
////protocol FrameRateToggleDelegate: AnyObject {
////    func toggleFrameRateView()
////}
//
//class SpriteViewModel: ObservableObject {
//    let scene: SKScene
//
//    @Published var currentFrameRate: Int = 0
//    @Published var isFrameRateCountVisible: Bool = true
//    @Published var isNodeCountVisible: Bool = true
//    private var frameCount: Int = 0
//    private var startTime: CFAbsoluteTime = 0.0
//    private var displayLink: CVDisplayLink?
//
//    @Published var nodeCount: Int = 0
//    private var nodeCountTimer: Timer?
//
//    //weak var delegate: FrameRateToggleDelegate?
//
//    init(scene: SKScene) {
//        self.scene = scene//SKScene(size: CGSize(width: 300, height: 300)) // Replace with your scene setup
//        //startUpdatingFrameRate()
//        //startUpdatingNodeCount()
//        setNodeCountVisibility = {
//            self.isNodeCountVisible = $0
//        }
//        setFrameRateVisibility = {
//            self.isNodeCountVisible = $0
//        }
//        //isFrameRateCountVisible = false
//        //isNodeCountVisible = false
//
//        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
//        CVDisplayLinkSetOutputCallback(displayLink!, displayLinkCallback, Unmanaged.passUnretained(self).toOpaque())
//        CVDisplayLinkStart(displayLink!)
//    }
//
//    func toggleFrameRateCountVisibility() {
//        isFrameRateCountVisible.toggle()
//    }
//
//    func toggleNodeCountVisibility() {
//        isNodeCountVisible.toggle()
//    }
//
//    func startUpdatingFrameRate() {
//        startTime = CFAbsoluteTimeGetCurrent()
//    }
//
//    func stopUpdatingFrameRate() {
//        CVDisplayLinkStop(displayLink!)
//        displayLink = nil
//    }
//
//    let displayLinkCallback: CVDisplayLinkOutputCallback = { (displayLink, inNow, inOutputTime, flagsIn, flagsOut, displayLinkContext) -> CVReturn in
//        let viewModel = Unmanaged<SpriteViewModel>.fromOpaque(displayLinkContext!).takeUnretainedValue()
//
//        viewModel.frameCount += 1
//
//        let currentTime = CFAbsoluteTimeGetCurrent()
//        let elapsedTime = currentTime - viewModel.startTime
//
//        if elapsedTime >= 1.0 {
//            DispatchQueue.main.sync {
//                viewModel.currentFrameRate = Int((Double(viewModel.frameCount) / elapsedTime) * 10)
//            }
//            viewModel.frameCount = 0
//            viewModel.startTime = currentTime
//        }
//
//        return kCVReturnSuccess
//    }
//
//    func startUpdatingNodeCount() {
//        nodeCountTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//            self?.updateNodeCount()
//        }
//    }
//
//    func stopUpdatingNodeCount() {
//        nodeCountTimer?.invalidate()
//        nodeCountTimer = nil
//    }
//
//    private func updateNodeCount() {
//        DispatchQueue.main.async { [weak self] in
//            self?.nodeCount = totalNodes// self?.scene.totalChildrenRecursive() ?? 0// .children.count ?? 0
//        }
//    }
//}
//
////// ViewModel to manage SpriteKit scene and fps/node count
////class SpriteViewModel: ObservableObject {
////    @Published var scene: SKScene
////    @Published var fps: Int = 0
////    @Published var nodeCount: Int = 0
////
////    private var timer: AnyCancellable?
////    private var nodeCountTimer: Timer?
////
////    init(scene: SKScene) {
////        self.scene = scene
////
////        startUpdatingNodeCount()
////
////        // Calculate FPS
////        self.timer = Timer.publish(every: 1.0, on: .main, in: .common)
////            .autoconnect()
////            .sink { [weak self] _ in
////                self?.fps = 60
////                self?.fps = 60 / (self?.scene.view?.frameInterval ?? 1)
////                //self?.fps = Int(1.0 / (self?.scene.view?.frameInterval ?? 1.0))
////                //self?.fps = Int(1.0 / (self?.scene.view?.frameInterval ?? 1.0))
////            }
////    }
////
////    func startUpdatingNodeCount() {
////        nodeCountTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
////            self?.updateNodeCount()
////        }
////    }
////
////    func stopUpdatingNodeCount() {
////        nodeCountTimer?.invalidate()
////        nodeCountTimer = nil
////    }
////
////    private func updateNodeCount() {
////        DispatchQueue.main.async { [weak self] in
////            self?.nodeCount = self?.scene.totalChildrenRecursive() ?? 0// .children.count ?? 0
////        }
////    }
////}
////
