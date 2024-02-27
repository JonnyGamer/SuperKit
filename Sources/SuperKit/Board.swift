//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 2/26/24.
//

import Foundation
public class Board: Node, Size {
    
    public let rows: Int
    public let columns: Int
    private var boxen : [Box] = []
    public var width: Double
    public var height: Double
    
    private var _tileScale: Double = 1.0
    public var tileScale: Double {
        get { _tileScale }
        set {
            _tileScale = newValue
            for i in boxen {
                i.node.scale = newValue
            }
        }
    }
    
    @discardableResult
    public init(width: Int, height: Int, maxWidth: Double = 1600, maxHeight: Double = 1000, execute: (() -> ())? = nil) {
        self.rows = height
        self.columns = width
        let blockSize = Double( min( maxHeight / Double(rows), maxWidth / Double(columns) ))
        self.width = blockSize * Double(width)
        self.height = blockSize * Double(height)
        super.init()
        
        //let (widthBound, heightBound) = keepInside
        // let xDiff = 1600 - (blockSize * Double(columns))
        // let yDiff = 1000 - (blockSize * Double(rows))
        
        // let blockSize : Double = 100
        
        self {
            
            for row in 1...self.rows {
                for column in 1...self.columns {
                    
                    Box(width: blockSize, height: blockSize) {
                        this.color = .black
                        this.x = Double(column) * blockSize - (this.width / 2) //+ xDiff/2
                        this.y = Double(row) * blockSize - (this.height / 2) //+ yDiff/2
                        //this.scale = 1.0
                        //this.name = "\(row)-\(column)"
    //                    this.whenTapped {
    //                        self.tapBox(x: row, y: column)
    //                    }
                    }
                    //self.boxen.append(box)
                    
                    let box = Box(width: blockSize, height: blockSize) {
                        this.color = .white
                        this.x = Double(column) * blockSize - (this.width / 2) //+ xDiff/2
                        this.y = Double(row) * blockSize - (this.height / 2) //+ yDiff/2
                        this.scale = 1.0//max(0.0, min(1.0, scale))
                        this.name = "\(row)-\(column)"
    //                    this.whenTapped {
    //                        self.tapBox(x: row, y: column)
    //                    }
                    }
                    self.boxen.append(box)
                }
            }
            
            execute?()
            
        }
    }
    
    public func find(x: Int, y: Int,_ activity: @escaping () -> ()) {
        if x < 0 || x >= columns { return }
        if y < 0 || y >= rows { return }
        boxen[x + y * columns].node {
            activity()
        }
    }
    
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}
