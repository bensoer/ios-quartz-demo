//
//  Drawing.swift
//  quartz2D
//
//  Created by Ben Soer on 2015-02-13.
//  Copyright (c) 2015 bensoer. All rights reserved.
//

import Foundation
import UIKit




public class Drawing{
    
    
    var shape:Shape
    
    var color:UIColor;
    
    var firstTouchLocation:CGPoint = CGPointZero;
    
    var lastTouchLocation:CGPoint = CGPointZero;
    
    init(_ shape:Shape, _ color:UIColor){
        self.shape = shape;
        self.color = color;
    }
   
    
    
    

}