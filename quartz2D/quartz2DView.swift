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

    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        self.newDrawing = Drawing(shape,currentColor);
        super.init(coder: aDecoder);
        
    }
    
    //Application-settable properties
    var shape = Shape.Line;
    var currentColor = UIColor.redColor();
    var useRandomColor = false;
    
    var drawings = [Drawing]();
    var newDrawing:Drawing;
    
    //Internal Properties
    //private let image = UIImage(named: "iphone")!;
    private var firstTouchLocation:CGPoint = CGPointZero;
    private var lastTouchLocation:CGPoint = CGPointZero;

    internal func clearDrawings(){
        drawings.removeAll();
        setNeedsDisplay();
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        if useRandomColor {
            currentColor = UIColor.randomColor();
        }
        let touch = touches.anyObject() as UITouch;
        firstTouchLocation = touch.locationInView(self);
        lastTouchLocation = firstTouchLocation;
        
        newDrawing = Drawing(shape, currentColor);
        newDrawing.firstTouchLocation = firstTouchLocation;
        newDrawing.lastTouchLocation = lastTouchLocation;
        newDrawing.color = currentColor;
        drawings.append(newDrawing);
        
        setNeedsDisplay();
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent){
        let touch = touches.anyObject() as UITouch;
        lastTouchLocation = touch.locationInView(self);
        
        newDrawing = drawings.removeLast();
        
        newDrawing.lastTouchLocation = lastTouchLocation;
        drawings.append(newDrawing);
        
        setNeedsDisplay();
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent){
        let touch = touches.anyObject() as UITouch;
        lastTouchLocation = touch.locationInView(self);
        
        var newDrawing = Drawing(shape, currentColor);
        newDrawing.firstTouchLocation = firstTouchLocation;
        newDrawing.lastTouchLocation = lastTouchLocation;
        newDrawing.color = currentColor;
        drawings.append(newDrawing);
        
        setNeedsDisplay();
    }
    
    

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0);
        
        
        for drawnShape in drawings{
            
            CGContextSetStrokeColorWithColor(context, drawnShape.color.CGColor);
            CGContextSetFillColorWithColor(context, drawnShape.color.CGColor);
            
            let currentRect = CGRectMake(drawnShape.firstTouchLocation.x, drawnShape.firstTouchLocation.y,
                drawnShape.lastTouchLocation.x - drawnShape.firstTouchLocation.x, drawnShape.lastTouchLocation.y - drawnShape.firstTouchLocation.y);
            
            
            switch drawnShape.shape {
            case .Line:
                CGContextMoveToPoint(context, drawnShape.firstTouchLocation.x, drawnShape.firstTouchLocation.y);
                CGContextAddLineToPoint(context, drawnShape.lastTouchLocation.x, drawnShape.lastTouchLocation.y);
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
    

}
