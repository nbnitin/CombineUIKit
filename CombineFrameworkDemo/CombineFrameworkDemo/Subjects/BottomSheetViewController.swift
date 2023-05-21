//
//  BottomSheetViewController.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 12/05/23.
//

import UIKit
import Combine

class BottomSheetViewController: UIViewController {

    //outelts
    @IBOutlet weak var progressValue1: UISlider!
    @IBOutlet weak var progressValue2: UISlider!
    @IBOutlet weak var progressValue3: UISlider!
    
    //variables
    let value1CurrentValueSubject = CurrentValueSubject<Float,Never>(INITIAL_VALUE)
    let value2CurrentValueSubject = CurrentValueSubject<Float,Never>(INITIAL_VALUE)
    let value3CurrentValueSubject = CurrentValueSubject<Float,Never>(INITIAL_VALUE)
    let stateCurrentValueSubject = PassthroughSubject<String,Never>()
    
    lazy var sliderTitle: UILabel = {
        let title = UILabel()
        title.text = ""
        title.textAlignment = .center
        title.numberOfLines = 1
        return title
    }()
    
    var lbl : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl = sliderTitle
        lbl.backgroundColor = .lightGray.withAlphaComponent(0.1)
        view.addSubview(lbl)
        view.bringSubviewToFront(lbl)
//            lbl.layer.zPosition = 1

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedOptions(_ sender: Any) {
        if let control = sender as? UISegmentedControl {
            stateCurrentValueSubject.send(control.titleForSegment(at: control.selectedSegmentIndex)!)
        }
    }
    
    
    @IBAction func progressBar(_ sender: Any) {
        if let slider = sender as? UISlider {
            animateSliderLabel(show: slider.isTracking)
            switch slider {
            case progressValue1:
                value1CurrentValueSubject.send(slider.value)
            case progressValue2:
                value2CurrentValueSubject.send(slider.value)
            case progressValue3:
                value3CurrentValueSubject.send(slider.value)
            default:
                break
            }

            lbl.frame.size = CGSize(width: 30, height: 30)
            let trackRect = slider.trackRect(forBounds: slider.frame)
            let thumbRect = slider.thumbRect(forBounds: slider.bounds, trackRect: trackRect, value: slider.value)
            lbl.center = CGPoint(x: thumbRect.midX + 15, y: lbl.center.y)
            lbl.frame.origin.y = (slider.superview?.frame.origin.y ?? 34) + 30
            lbl.text = String(format: "%.1f", slider.value)
        }
    }
    
    func animateSliderLabel(show: Bool) {
        UIView.animate(withDuration: 0.6, animations: {
            self.lbl.alpha = show ? 1 : 0
        }, completion: {_ in
            self.lbl.isHidden = !show
        })
    }
    
}
