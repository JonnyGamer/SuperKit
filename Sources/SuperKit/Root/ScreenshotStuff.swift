//
//  ScreenshotStuff.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/31/23.
//

import SpriteKit

var highRes: Bool = false

extension SKScene {
    
    func getScreenshot(scale: Double = 1.0) -> NSImage {
        
        var scale = scale
        if highRes {
            scale = scale / 2
        }
        
        let screenShotWindow = CGSize.ratio(6, 9).keepInside(.ratio(width*scale, height*scale)) //CGSize.ratio(6, 9).keepInside(.ratio(width, height))
        let portionRect = CGRect.init(x: width/2, y: height/2, width: width*scale, height: height*scale)
        // Assuming 'scene' is your SKScene and 'portionRect' is the CGRect representing the portion you want to capture
        guard let skView = self.view else { fatalError("No SKScene") }
        guard let scene = self.scene else { fatalError("No SKScene") }
        guard let capturedImage = skView.texture(from: scene, crop: portionRect)?.toNSImage() else { fatalError("NUU") }
        
        let highResMultiply: Double = highRes ? 2 : 1
        // Make sure I did this math right for high res stuff lol
        let croppedImage = cropPNGImage(capturedImage, rect: .init(origin: .init(x: highResMultiply*capturedImage.size.width/2 - highResMultiply*screenShotWindow.width/2, y: 0), size: screenShotWindow.times(highResMultiply)))
        return croppedImage
        
//        let screenShotWindow = CGSize.ratio(6, 9).keepInside(.ratio(width*scale, height*scale)) //CGSize.ratio(6, 9).keepInside(.ratio(width, height))
//        let portionRect = CGRect.init(x: width/2, y: height/2, width: width*scale, height: height*scale)
//        // Assuming 'scene' is your SKScene and 'portionRect' is the CGRect representing the portion you want to capture
//        guard let skView = self.view else { fatalError("No SKScene") }
//        guard let scene = self.scene else { fatalError("No SKScene") }
//        guard let capturedImage = skView.texture(from: scene, crop: portionRect)?.toNSImage() else { fatalError("NUU") }
//        let croppedImage = cropPNGImage(capturedImage, rect: .init(origin: .init(x: capturedImage.size.width/2 - screenShotWindow.width, y: 0), size: screenShotWindow.times(2)))
//        return croppedImage
    }
    
    func saveScreenshot(scale: Double = 1.0) {
        
        var scale = scale
        if highRes {
            scale = scale / 2
        }
        
        let screenShotWindow = CGSize.ratio(6, 9).keepInside(.ratio(width*scale, height*scale)) //CGSize.ratio(6, 9).keepInside(.ratio(width, height))
        let portionRect = CGRect.init(x: width/2, y: height/2, width: width*scale, height: height*scale)
        // Assuming 'scene' is your SKScene and 'portionRect' is the CGRect representing the portion you want to capture
        guard let skView = self.view else { fatalError("No SKScene") }
        guard let scene = self.scene else { fatalError("No SKScene") }
        guard let capturedImage = skView.texture(from: scene, crop: portionRect)?.toNSImage() else { fatalError("NUU") }
        
        let highResMultiply: Double = highRes ? 2 : 1
        // Make sure I did this math right for high res stuff lol
        let croppedImage = cropPNGImage(capturedImage, rect: .init(origin: .init(x: highResMultiply*capturedImage.size.width/2 - highResMultiply*screenShotWindow.width/2, y: 0), size: screenShotWindow.times(highResMultiply)))
        saveImageToDownloads(image: croppedImage, filename: "HelloWorldMystics\(Int.random(in: 1...100)).png")
        //saveSVGToFile(createSVG(), fileName: "OK.svg")

//        let screenShotWindow = CGSize.ratio(6, 9).keepInside(.ratio(width, height)) //CGSize.ratio(6, 9).keepInside(.ratio(width, height))
//        let portionRect = CGRect.init(x: width/2, y: height/2, width: width, height: height)
//        // Assuming 'scene' is your SKScene and 'portionRect' is the CGRect representing the portion you want to capture
//        guard let skView = self.view else { fatalError("No SKScene") }
//        guard let scene = self.scene else { fatalError("No SKScene") }
//        guard let capturedImage = skView.texture(from: scene, crop: portionRect)?.toNSImage() else { fatalError("NUU") }
//        let croppedImage = cropPNGImage(capturedImage, rect: .init(origin: .init(x: capturedImage.size.width/2 - screenShotWindow.width, y: 0), size: screenShotWindow.times(1)))
//        saveImageToDownloads(image: croppedImage, filename: "HelloWorldMystics\(Int.random(in: 1...100)).png")
//        //saveSVGToFile(createSVG(), fileName: "OK.svg")
    }
}


func cropPNGImage(_ inputImage: NSImage, rect: CGRect) -> NSImage {
    guard let cgImage = inputImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
        fatalError()
    }
    
    guard let croppedCGImage = cgImage.cropping(to: rect) else { fatalError("Cropping Failed") }
    
    return NSImage(cgImage: croppedCGImage, size: rect.size)
}

extension SKTexture {
    func toNSImage() -> NSImage {
        let cgImage = self.cgImage()
        return NSImage(cgImage: cgImage, size: CGSize(width: cgImage.width, height: cgImage.height))
    }
}

func saveImageToDownloads(image: NSImage, filename: String) {
    guard let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
        return
    }
    
    let fileURL = downloadsDirectory.appendingPathComponent(filename)
    //image.tiffRepresentation
    if let imageData = image.tiffRepresentation(using: .packBits, factor: 1.0) {
        do {
            try imageData.write(to: fileURL)
        } catch {
            print("Error saving image: \(error)")
        }
    }
}


//func createSVG() -> String {
//    var svgContent = """
//    <?xml version="1.0" encoding="UTF-8"?>
//    <svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">
//    """
//
//    // Add an image
//    svgContent += """
//    <image x="50" y="50" width="200" height="200" xlink:href="zeno.jpg" />
//    """
//
//    // Add a bezier curve
//    svgContent += """
//    <path d="M100 300 C150 100, 350 100, 400 300" stroke="black" fill="transparent" />
//    """
//
//    svgContent += "</svg>"
//
//    return svgContent
//}
//
//func saveSVGToFile(_ svgContent: String, fileName: String) {
//    do {
//        let fileURL = try FileManager.default
//            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            .appendingPathComponent(fileName)
//        try svgContent.write(to: fileURL, atomically: true, encoding: .utf8)
//        print("SVG saved to: \(fileURL.path)")
//    } catch {
//        print("Error saving SVG: \(error)")
//    }
//}
