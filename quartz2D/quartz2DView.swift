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
        self.newDrawing = Drawing(shape,currentColor);
        super.init(coder: aDecoder);
        
    }
    
    //Application-settable properties
    var shape = Shape.Line;
    var currentColor = UIColor.redColor();
    var useRandomColor = false;
    
    var drawings = [Drawing]();
    var newDrawing:Drawing;
    
    //clear all drawings on the view
    internal func clearDrawings(){
        drawings.removeAll();
        setNeedsDisplay();
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        //if random color selected, generate new random color
        if (useRandomColor) {
            currentColor = UIColor.randomColor();
        }
        
        let touch = touches.anyObject() as UITouch;
        
        //create new drawing object
        newDrawing = Drawing(shape, currentColor);
        newDrawing.firstTouchLocation = touch.locationInView(self);
        newDrawing.lastTouchLocation = newDrawing.firstTouchLocation;
        newDrawing.color = currentColor;
        //add to array of drawings
        drawings.append(newDrawing);
        
        setNeedsDisplay();
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent){
        let touch = touches.anyObject() as UITouch;
       
        //get last drawings (its the one we worked on last)
        newDrawing = drawings.removeLast();
        //update it and put it back in the array
        newDrawing.lastTouchLocation = touch.locationInView(self);
        drawings.append(newDrawing);
        
        setNeedsDisplay();
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent){
        let touch = touches.anyObject() as UITouch;
        
        //get last drawing (its the one we worked on last)
        newDrawing = drawings.removeLast();
        //update it and put it back in the array
        newDrawing.lastTouchLocation = touch.locationInView(self);
        newDrawing.color = currentColor;
        drawings.append(newDrawing);
        
        setNeedsDisplay();
    }
    
    

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0);
        
        //draw every drawings in the array of drawings we previously made
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
