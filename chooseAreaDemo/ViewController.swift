//
//  ViewController.swift
//  chooseAreaDemo
//
//  Created by Bart Simpsons on 2018/8/24.
//  Copyright © 2018年 simpsons. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var livingInfo:AreaInfoModel = AreaInfoModel()
    
    @IBOutlet weak var addressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func chooseIt(_ sender: Any) {
        
        
        let choose = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BSChooseAreaCtrl") as! BSChooseAreaCtrl
        choose.modalPresentationStyle = UIModalPresentationStyle.custom
        choose.addressInfo = self.livingInfo
        choose.chooseArea = {
            model in
            
            print(model)
            self.livingInfo = model
            self.showName()
            
        }
        
        self.present(choose, animated: true, completion: nil)
    }
    
    func showName(){
        
        func getTitle(_ ti:String) -> String {
            
            return ti == "" ? "" : " \(ti)"
        }
        let cityName = self.livingInfo.cityName
        let province = self.livingInfo.provinceName
        var address = ""
        if !province.isEmpty{
            let pAndC = cityName == province ? cityName : "\(province) \(cityName)"
            address = pAndC + getTitle(self.livingInfo.areaName) + getTitle(self.livingInfo.streetName) + getTitle(self.livingInfo.villageName)
        }
        
        addressLabel.text = address
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

