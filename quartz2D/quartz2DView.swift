//
//  quartz2DView.swift
//  quartz2D
//
//  Created by Ben Soer on 2015-02-11.
//  Copyright (c) 2015 bensoer. All rights reserved.
//

import UIKit

extension UIColor {
    class func randomColor() -> UIColor {
        let red = CGFloat(Double((arc4random() % 256 )) / 255);
        let green = CGFloat(Double((arc4random() % 256 )) / 255);
        let blue = CGFloat(Double((arc4random() % 256 )) / 255);
        
        return UIColor(red: red, green: green, blue: blue , alpha:1.0);
        
    }
}

enum Shape: UInt {
    case Line = 0, Rect, Ellipse, Image;
}

enum DrawingColor: UInt{
    case Red = 0, Blue, Yellow, Green, Random;
}

class quartz2DView: UIView {
    //Application-settable properties
    var shape = Shape.Line;
    var currentColor = UIColor.redColor();
    var useRandomColor = false;
    
    //Internal Properties
    //private let image = UIImage(named: "iphone")!;
    private var firstTouchLocation:CGPoint = CGPointZero;
    private var lastTouchLocation:CGPoint = CGPointZero;

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        if useRandomColor {
            currentColor = UIColor.randomColor();
        }
        let touch = touches.anyObject() as UITouch;
        firstTouchLocation = touch.locationInView(self);
        lastTouchLocation = firstTouchLocation;
        setNeedsDisplay();
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent){
        let touch = touches.anyObject() as UITouch;
        lastTouchLocation = touch.locationInView(self);
        setNeedsDisplay();
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent){
        let touch = touches.anyObject() as UITouch;
        lastTouchLocation = touch.locationInView(self);
        setNeedsDisplay();
    }
    
    

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, currentColor.CGColor);
        CGContextSetFillColorWithColor(context, currentColor.CGColor);
        
        let currentRect = CGRectMake(firstTouchLocation.x, firstTouchLocation.y,
            lastTouchLocation.x - firstTouchLocation.x, lastTouchLocation.y - firstTouchLocation.y);
        
        
        switch shape {
        case .Line:
            CGContextMoveToPoint(context, firstTouchLocation.x, firstTouchLocation.y);
            CGContextAddLineToPoint(context, lastTouchLocation.x, lastTouchLocation.y);
            CGContextStrokePath(context);
        case .Rect:
            CGContextAddRect(context, currentRect);
            CGContextDrawPath(context, kCGPathFillStroke);
        case .Ellipse:
            CGContextAddEllipseInRect(context, currentRect);
            CGContextDrawPath(context, kCGPathFillStroke);
        case .Image:
            break;
        }
    }
    

}
