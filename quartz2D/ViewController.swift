//
//  ViewController.swift
//  quartz2D
//
//  Created by Ben Soer on 2015-02-11.
//  Copyright (c) 2015 bensoer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var colorControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeColor(sender: UISegmentedControl) {
        let drawingColorSelection = DrawingColor(rawValue: UInt(sender.selectedSegmentIndex));
        if let drawingColor = drawingColorSelection{
            let quartz2DView = view as quartz2D.quartz2DView; //textbook makes a mistake here
            switch drawingColor {
            case .Red:
                quartz2DView.currentColor = UIColor.redColor();
                quartz2DView.useRandomColor = false;
            case .Blue:
                quartz2DView.currentColor = UIColor.blueColor();
                quartz2DView.useRandomColor = false;
            case .Yellow:
                quartz2DView.currentColor = UIColor.yellowColor();
                quartz2DView.useRandomColor = false;
            case .Green:
                quartz2DView.currentColor = UIColor.greenColor();
                quartz2DView.useRandomColor = false;
            case .Random:
                quartz2DView.useRandomColor = true;
            default:
                break;
            }
            
        }
    }

    @IBAction func changeShape(sender: AnyObject) {
        let shapeSelection = Shape(rawValue: UInt(sender.selectedSegmentIndex));
        if let shape = shapeSelection {
            let quartz2DView = view as quartz2D.quartz2DView;
            quartz2DView.shape = shape;
            colorControl.hidden = shape == Shape.Image;
        }
    }
}

