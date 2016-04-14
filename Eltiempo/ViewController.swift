//
//  ViewController.swift
//  Eltiempo
//
//  Created by CLAG on 2/4/16.
//  Copyright © 2016 Clag. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userCity: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        userCity.delegate = self
    }
    

    @IBAction func findWeather(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        let url = NSURL(string:"http://es.weather-forecast.com/locations/" + userCity.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if url != nil{
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {(data, response, error) -> Void in
                var urlError = false
                var  weather = ""
                
                let urlContent = NSString(data:data!, encoding: NSUTF8StringEncoding)! as NSString
                
                let urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                
                if urlContentArray.count > 1 {
                    let weatherArray = urlContentArray[1].componentsSeparatedByString("</span")
                    
                    weather = weatherArray[0]
                    
                    weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                    
                }
                else {
                    urlError = true
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    if urlError == true {
                        self.showError()
                    }
                    else {
                        self.resultLabel.text = weather
                    }
                })
                
            })
            
            task.resume()
        }
        else{
            showError()
        }

    }
    
    func showError(){
        resultLabel.text = "No se puedo encontrar el tiempo en " + userCity.text! + ". Por favor, inténtalo de nuevo"
    }

    // MARK: - Keyboard

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.findWeather(self)
        
        return true
        
    }

}

