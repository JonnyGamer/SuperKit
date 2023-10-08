//
//  Parts.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 7/31/23.
//

import SpriteKit
import CoreImage
import Vision
import SpriteKit


extension SKSpriteNode {
    func hasTransparentPixels() -> Bool {
        guard let texture = self.texture else {
            // If the sprite node doesn't have a texture, it cannot have transparent pixels.
            return false
        }
        
        // Get the pixel data from the texture
        let pixelData = texture.cgImage().dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        // Get the size of the texture
        let width = Int(texture.size().width)
        let height = Int(texture.size().height)
        let bitsPerPixel = 4 // Assuming it's a 32-bit image (8 bits per channel RGBA)
        
        // Iterate through the pixel data to check the alpha channel
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (y * width + x) * bitsPerPixel
                let alphaValue = data[pixelIndex + 3]
                
                if alphaValue != 255 {
                    // If the alpha value is not fully opaque (255), there are transparent pixels.
                    return true
                }
            }
        }
        
        // No transparent pixels found
        return false
    }
}

func separateParts(from spriteNode: SKSpriteNode) -> [_Image] {
    guard let spriteTexture = spriteNode.texture else {
        return []
    }
    let cgImage = spriteTexture.cgImage()
    
    // Helper function to check if a pixel is transparent
    func isPixelTransparent(at point: CGPoint) -> Bool {
        let x = Int(point.x)
        let y = Int(point.y)

        if let pixelData = cgImage.dataProvider?.data,
           let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData) {
            let pixelInfo: Int = ((cgImage.width * y) + x) * 4 // 4 bytes per pixel (RGBA)
            let alpha = data[pixelInfo + 3] // Alpha value is the 4th byte

            return alpha == 0
        }

        return false
    }
    
    // Helper function to flood-fill a region starting from a given point
    func floodFill(from point: CGPoint, visited: inout Set<CGPoint>, region: inout CGRect?, maxW: Int, maxH: Int) {

        var unvisited: Set<CGPoint> = [point]
        
        while !unvisited.isEmpty {
            let point = unvisited.removeFirst()
            
            if point.x < 0 { continue }
            if point.y < 0 { continue }
            if Int(point.x) >= maxW { continue }
            if Int(point.y) >= maxH { continue }
            if visited.contains(point) {
                continue
            } else if isPixelTransparent(at: point) {
                visited.insert(point)
                continue
            }
            visited.insert(point)
            let pixel = CGRect(origin: point, size: CGSize(width: 1, height: 1))
            region = region?.union(pixel) ?? pixel
            
            unvisited.insert(CGPoint(x: point.x + 1, y: point.y))
            unvisited.insert(CGPoint(x: point.x - 1, y: point.y))
            unvisited.insert(CGPoint(x: point.x, y: point.y + 1))
            unvisited.insert(CGPoint(x: point.x, y: point.y - 1))
        }
    }
    
    var separateImagePieces: [_Image] = []
    var visitedPoints: Set<CGPoint> = []
    //print(cgImage.width * cgImage.height)
    
      for y in 0..<cgImage.height {
          for x in 0..<cgImage.width {
              // ... (the rest of the previous code remains unchanged)
              let point = CGPoint(x: x, y: y)
              
              if visitedPoints.contains(point) {
                  continue
              }
              if isPixelTransparent(at: point) {
                  continue
              }
  
              
              var region: CGRect?
              floodFill(from: point, visited: &visitedPoints, region: &region, maxW: cgImage.width, maxH: cgImage.height)
            
              if let region = region, region.size.width > 0 && region.size.height > 0 {
                  //print(region)
                  let partCGImage = cgImage.cropping(to: region)!
                  let partTexture = SKTexture(cgImage: partCGImage)

                  // Calculate the actual position of the extracted part relative to the sprite node
                  let partX = -Double(cgImage.width)/2 + region.origin.x + region.size.width/2
                  let partY = Double(cgImage.height)/2 - region.origin.y - region.size.height/2
                  
                  let image = _Image.init(partTexture)
                  //let image = SKSpriteNode(texture: partTexture).image
                  // image.__sprite__.anchorPoint = .zero
                  image.x = partX
                  image.y = partY
                  
                  let imagePiece = image// ImagePiece(texture: partTexture, position: CGPoint(x: partX, y: partY))
                  separateImagePieces.append(imagePiece)
              }
              
          }
      }
    //print("COMPLETE")
      return separateImagePieces
}
