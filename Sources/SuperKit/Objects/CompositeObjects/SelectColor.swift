//
//  SelectColor.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/24/23.
//

class ColorPicker<T: AnyObject>: NodeView {
    let text: String
    let getStatus: () -> Color
    let setStatus: (Color) -> ()
    
    public var node: Node!
    public var body: Node {
        RoundWindow(width: 300, height: 150) {
            Padding(20) {
                VStack {
                    Padding(20) {
                        Window(width: 300, height: 25) {
                            Text(self.text)
                        }
                    }
                    this.vstack.spacing = 10
                    HStack {
                        this.hstack.spacing = 10
                        
                        Box(width: 30, height: 30) {
                            this.color = .redSelection
                            this.whenTapped {
                                self.setStatus(this.color)
                            }
                        }
                        Box(width: 30, height: 30) {
                            this.color = .orange
                            this.whenTapped {
                                self.setStatus(this.color)
                            }
                        }
                        Box(width: 30, height: 30) {
                            this.color = .darkYellow
                            this.whenTapped {
                                self.setStatus(this.color)
                            }
                        }
                        Box(width: 30, height: 30) {
                            this.color = .green
                            this.whenTapped {
                                self.setStatus(this.color)
                            }
                        }
                        Box(width: 30, height: 30) {
                            this.color = .blue
                            this.whenTapped {
                                self.setStatus(this.color)
                            }
                        }
                        Box(width: 30, height: 30) {
                            this.color = .darkBlue
                            this.whenTapped {
                                self.setStatus(this.color)
                            }
                        }
                        Box(width: 30, height: 30) {
                            this.color = .purple
                            this.whenTapped {
                                self.setStatus(this.color)
                            }
                        }
                    }
                    HStack {
                        this.hstack.spacing = 10
                        
                        Box(width: 30, height: 30) {
                            this.color = .lightGray
                            Box(width: 25, height: 25) {
                                this.color = .white
                                this.whenTapped {
                                    self.setStatus(this.color)
                                }
                            }
                        }
                        
                        Box(width: 30, height: 30) {
                            this.color = .lightGray
                            this.whenTapped {
                                self.setStatus(this.color)
                            }
                        }
                        Box(width: 30, height: 30) {
                            this.color = .darkGray
                            this.whenTapped {
                                self.setStatus(this.color)
                            }
                        }
                        Box(width: 30, height: 30) {
                            this.color = .black
                            this.whenTapped {
                                self.setStatus(this.color)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @discardableResult
    init(text: String, node: T, status: ReferenceWritableKeyPath<T, Color>) {
        self.text = text
        self.getStatus = { node[keyPath: status] }
        self.setStatus = { node[keyPath: status] = $0 }
        self.node = body
    }
    
}
