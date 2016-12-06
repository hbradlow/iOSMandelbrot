//
//  ViewController.swift
//  mandlebrot
//
//  Created by Henry Bradlow on 12/6/16.
//  Copyright © 2016 Henry Bradlow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var current_l = CGFloat(0)
    var current_x = CGFloat(0)
    var current_y = CGFloat(0)
    var num_iterations = 0
    
    var d = CGFloat(0)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        d = min(view.frame.size.width, view.frame.size.height)
        reset(view)
    }
    
    @IBAction func increaseMaxIterations(_ sender: Any) {
        num_iterations += 100
        render(cx: current_x, cy: current_y, l: current_l)
    }
    
    @IBAction func reset(_ sender: Any) {
        current_l = CGFloat(2)
        current_x = CGFloat(0)
        current_y = CGFloat(0)
        num_iterations = 50
        render(cx: current_x, cy: current_y, l: current_l)
    }
    
    func render(cx: CGFloat, cy: CGFloat, l: CGFloat) {

        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        let min_x_val = cx - l
        let max_x_val = cx + l
        
        let min_y_val = cy - l
        let max_y_val = cy + l
        
        for ix in stride(from: 0, through: d, by: 1){
            for iy in stride(from: 0, through: d, by: 1){
                let x = (ix - d/2.0) * CGFloat(max_x_val - min_x_val) / d + cx
                let y = (iy - d/2.0) * CGFloat(max_y_val - min_y_val) / d + cy
                
                var zx = CGFloat(0)
                var zy = CGFloat(0)
                
                for i in 0...num_iterations {
                    if zx*zx + zy*zy > 2*2 {
                        let v = CGFloat(i)/CGFloat(num_iterations)
                        context?.setFillColor(UIColor(hue: v, saturation: 0.5, brightness: 1, alpha: 1).cgColor)
                        context?.fill(CGRect(x: ix, y: iy, width: 1, height: 1))
                        break
                    }
                    if i == num_iterations {
                        context?.setFillColor(red: 0, green: 0, blue: 0, alpha: 1)
                        context?.fill(CGRect(x: ix, y: iy, width: 1, height: 1))
                    }
                    
                    let temp = zx * zx + x - zy * zy
                    zy = 2 * zx * zy + y
                    zx = temp
                }
            }
        }
        
        imageView.image = nil
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        imageView.alpha = 1.0
        UIGraphicsEndImageContext()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let w = view.frame.size.width
            let h = view.frame.size.height
            
            current_x = ((touch.location(in: view).x - d/2) * current_l * 2 / w) + current_x
            current_y = ((touch.location(in: view).y - d/2) * current_l * 2 / h) + current_y
            
            num_iterations += 100
            current_l = current_l/2
            
            render(cx: current_x, cy: current_y, l: current_l)
            
        }
        super.touchesBegan(touches, with: event)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

