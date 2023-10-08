//
//  JSONFileManager.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/31/23.
//

import Foundation
import SpriteKit

//private var _foolsHash: Int? = nil
//func foolsHash() -> Int {
//    if let f = _foolsHash { return f }
//    _foolsHash = SKTexture.init(imageNamed: "create x image lol").hashValue
//    return _foolsHash!
//}

func imageExists(_ this: String) -> Bool {
    return SKTexture.init(imageNamed: this).size() != .init(width: 128 , height: 128)
}

class JSONFileManager {
    
    static var directories: [String] = []
    
    static func getDocumentDirectoryURL() -> URL? {
        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        for i in directories {
            if #available(macOS 13.0, *) {
                path?.append(path: i)
            } else {
                // Fallback on earlier versions
            }
        }
        return path
    }
    
    static func gainImage(_ named: String) -> NSImage! {
        let fileManager = FileManager.default
        
        guard let documentDirectory = getDocumentDirectoryURL() else {
            return NSImage.init(named: "___")// "___"
        }
        let imagePath = documentDirectory.appendingPathComponent(named + ".png")
        
        if fileManager.fileExists(atPath: imagePath.path) {
            // The image file exists in the document folder.
            //print(imagePath.path)
            //return imagePath.path
            return NSImage.init(contentsOf: imagePath)// "___"
        } else {
            // The image file does not exist. Handle this case accordingly.
        }
        return NSImage.init(named: "___")// "___"
    }
    
    static func retrieveJSONDocument(filename: String) -> Container? {
        var filename = filename
        if !filename.hasPrefix(".json") { filename += ".json" }
        
        guard let documentDirectory = getDocumentDirectoryURL() else {
            return nil
        }
        
        let fileURL = documentDirectory.appendingPathComponent(filename)
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(Container.self, from: jsonData)
            return decodedData
        } catch {
            print("Error retrieving JSON document: \(error)")
            
            return nil
        }
    }
    
    
    static func saveImageToDocument(filename: String, scale: Double) -> Bool {
        var filename = filename
        if !filename.hasPrefix(".png") { filename += ".png" }
        
        let image = trueScene.getScreenshot(scale: scale)
        
        guard let documentDirectory = getDocumentDirectoryURL() else {
            return false
        }
        
        let fileURL = documentDirectory.appendingPathComponent(filename)
        //image.tiffRepresentation(using: .packBits, factor: 1.0)
        
        if let imageData = image.tiffRepresentation(using: .packBits, factor: 1.0) {
            do {
                try imageData.write(to: fileURL)
                return true
            } catch {
                print("Error saving image: \(error)")
                return false
            }
        }
        return false
    }
    
    static func saveJSONDocument(data: Container, filename: String) -> Bool {
        var filename = filename
        if !filename.hasPrefix(".json") { filename += ".json" }
        
        guard let documentDirectory = getDocumentDirectoryURL() else {
            return false
        }
        
        let fileURL = documentDirectory.appendingPathComponent(filename)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(data)
            try jsonData.write(to: fileURL)
            return true
        } catch {
            print("Error saving JSON document: \(error)")
            return false
        }
    }

    static func createFolderInDocumentsDirectory(folderName: String) {
        guard let documentDirectory = getDocumentDirectoryURL() else { return }
        
        let folderURL = documentDirectory.appendingPathComponent(folderName)
        
        do {
            // Check if the folder already exists
            if !FileManager.default.fileExists(atPath: folderURL.path) {
                // Create the folder if it doesn't exist
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                //print("Folder created at: \(folderURL.path)")
            } else {
                //print("Folder already exists at: \(folderURL.path)")
            }
        } catch {
            // Handle any errors that occur during folder creation
            //print("Error creating folder: \(error)")
        }
    }

    
    enum FileExtensions: String {
        case json, folder = "", png
    }
    
    // Get a list of JSON files in the App's document directory
    static func listFiles(_ ofType: FileExtensions...) -> [String] {
        guard let documentDirectory = getDocumentDirectoryURL() else {
            return []
        }
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectory,
                                                                      includingPropertiesForKeys: nil,
                                                                      options: [])
            
            let finingFileExtensionsOf = ofType.map { $0.rawValue }
            
            let jsonFileURLs = fileURLs.filter {
                if $0.lastPathComponent == ".DS_Store" { return false }
                return finingFileExtensionsOf.contains($0.pathExtension)
            }
            let jsonFileNames = jsonFileURLs.map { $0.lastPathComponent }
            return jsonFileNames
        } catch {
            print("Error listing JSON files: \(error)")
            return []
        }
    }
    
    static func copyJSONFile(fromName: String, toName: String) {
        guard let documentDirectory = getDocumentDirectoryURL() else { return }
        
        do {
            let sourceURL = documentDirectory.appendingPathComponent(fromName+".json")
            let destinationURL = documentDirectory.appendingPathComponent(toName+".json")
            
            if FileManager.default.fileExists(atPath: sourceURL.path) {
                do {
                    try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                } catch {
                    
                }
            }
        }
        
        do {
            let sourceURL = documentDirectory.appendingPathComponent(fromName+"_preview.png")
            let destinationURL = documentDirectory.appendingPathComponent(toName+"_preview.png")
            
            if FileManager.default.fileExists(atPath: sourceURL.path) {
                do {
                    try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                } catch {
                    
                }
            }
        }
        
        do {
            let sourceURL = documentDirectory.appendingPathComponent(fromName+".png")
            let destinationURL = documentDirectory.appendingPathComponent(toName+".png")
            
            if FileManager.default.fileExists(atPath: sourceURL.path) {
                do {
                    try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                } catch {
                    
                }
            }
        }
    }

    static func copyImageToDownloadsFolder(imageName: String, tries: Int = 0) {
        
        guard let documentDirectory = getDocumentDirectoryURL() else { return }
        
        // Create a URL for the source image file in the document directory
        let sourceURL = documentDirectory.appendingPathComponent(imageName)
        
        // Check if the source file exists
        if FileManager.default.fileExists(atPath: sourceURL.path) {
            // Get the Downloads directory URL
            if let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first {
                // Create a URL for the destination image file in the Downloads directory
                var destination = imageName
                if tries > 0 {
                    destination.removeLast(4)
                    destination += " copy \(tries).png"
                }
                
                let destinationURL = downloadsDirectory.appendingPathComponent(destination)
                
                do {
                    // Copy the image from the document directory to the Downloads directory
                    try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                    // print("Image copied to Downloads folder.")
                } catch {
                    // Handle any errors that occur during the copy operation
                    // print("Error copying image: \(error)")
                    copyImageToDownloadsFolder(imageName: imageName, tries: tries + 1)
                }
            }
        } else {
            // print("Source image does not exist in the document directory.")
        }
    }

    
}
