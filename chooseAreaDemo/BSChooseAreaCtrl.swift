//
//  BSChooseAreaCtrl.swift
//  BIGCAR
//
//  Created by Bart Simpsons on 2018/8/16.
//  Copyright © 2018年 PP100. All rights reserved.
//

import UIKit

enum chooseListType:Int {
    case province = 0
    case city = 1
    case area = 2
    case street = 3
    case village = 4
}

let SCREENWIDTH = UIScreen.main.bounds.size.width

typealias chooseAreaClosure = (_ addressModel:AreaInfoModel) -> Void

class BSChooseAreaCtrl: UIViewController {

    private let cellName = "BSChooseAreaCell"
    
    var chooseArea:chooseAreaClosure?
    
    @IBOutlet weak var topHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var provinceBtn: UIButton!
    
    @IBOutlet weak var cityBtn: UIButton!
    
    @IBOutlet weak var areaBtn: UIButton!
    
    @IBOutlet weak var streetBtn: UIButton!
    
    @IBOutlet weak var line: UIView!
    
    fileprivate let topViewHeight:CGFloat = 124
    
    fileprivate var buttonArray:[UIButton] = []
    
    var addressInfo: AreaInfoModel!
    
    fileprivate var listType = chooseListType.province
    
    
    
    let testModel:[BSAreaModel] = [BSAreaModel.init("爱乐之城", id: "02"), BSAreaModel.init("黑城堡", id: "04"), BSAreaModel.init("君临城", id: "05"), BSAreaModel.init("旧镇", id: "06"), BSAreaModel.init("凯岩城", id: "07"), BSAreaModel.init("临冬城", id: "03"), BSAreaModel.init("瑞克城", id: "01"), BSAreaModel.init("鹰巢城", id: "10"), BSAreaModel.init("孪河城", id: "11"), BSAreaModel.init("风息堡", id: "12"), BSAreaModel.init("高庭", id: "13"), BSAreaModel.init("奔流城", id: "14"), BSAreaModel.init("赫伦堡", id: "15"), BSAreaModel.init("红堡", id: "16"), BSAreaModel.init("龙石岛", id: "17")]
    var allArray:[[BSAreaModel]] = [[],[],[],[],[]]
    
    var showName = ""
    var showIndex = 0
    
    lazy var checkImg:UIImageView = {
        let select = UIImageView.init(frame: CGRect.init(x: SCREENWIDTH - 26, y: 15, width: 15, height: 15))
        select.image = #imageLiteral(resourceName: "icon_Check")
        select.tag = 111
        return select
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allArray = [testModel, testModel, testModel, testModel, testModel]

        buttonArray = [provinceBtn, cityBtn, areaBtn, streetBtn]
        
        self.tableView.register(UINib.init(nibName: "BSChooseAreaCell", bundle: nil), forCellReuseIdentifier: "BSChooseAreaCell")
        self.tableView.separatorStyle = .none
        
        judgeType()
        
        // Do any additional setup after loading the view.
    }
    
    fileprivate func judgeType(){
        
        topHeight.constant = topViewHeight
        resetButtonTitle()

        if addressInfo.streetName != "" {
            
            showName = addressInfo.villageName
            listType = .village
            setupButtonTitle()
            getAreasData(addressInfo.streetId)
        }else if addressInfo.areaName != "" {
            
            listType = .street
            setupButtonTitle()
            getAreasData(addressInfo.areaId)
        }else if addressInfo.cityName != "" {

            listType = .area
            setupButtonTitle()
            getAreasData(addressInfo.cityId)
        }else if addressInfo.provinceName != "" {
            
            listType = .city
            setupButtonTitle()
            getAreasData(addressInfo.provinceId)
        }else {
            
            listType = .province
            getAreasData("")
            topHeight.constant = 40
        }
    }
    
    /// 数据请求
    fileprivate func getAreasData(_ inputID:String){
        
        let list = self.allArray[self.listType.rawValue]
        self.tableView.reloadData()
        
        for (index,data) in list.enumerated(){
            if data.name == self.showName {
                self.showIndex = index
                self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: index), at: UITableViewScrollPosition.top, animated: true)
                break
            }else{
                self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
            }
        }
        
        /*
         存在请求失败的情况，如果请求失败
         let typeNow = self.listType.rawValue == 0 ? self.listType.rawValue : self.listType.rawValue - 1
         if let type = chooseListType.init(rawValue: typeNow) {
            self.listType = type
         }
 
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            if let chooseArea = self.chooseArea {
                
                chooseArea(self.addressInfo)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BSChooseAreaCtrl:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allArray[listType.rawValue].count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch listType {
        case .province:
            return section == 0 ? 142 : CGFloat.leastNormalMagnitude
            
        default:
            return section == 0 ? 40 : CGFloat.leastNormalMagnitude
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard section == 0 else {
            return nil
        }
        
        let headerH:CGFloat = listType == .province ? 122 : 20
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: headerH))
        if listType == .province {
             header.addSubview(getHotCity())
        }
        let title = UILabel.init(frame: CGRect.init(x: 11, y: listType == .province ? 102 : 0, width: 200, height: 20))
        header.addSubview(title)
        setupTitle(title)
        title.text = "选择"
        
        return header
    }
    
    fileprivate func getHotCity() -> UIView {
        let head = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 82))
        let title = UILabel.init(frame: CGRect.init(x: 11, y: 20, width: 200, height: 20))
        head.addSubview(title)
        setupTitle(title)
        title.text = "热门城市"
        
        let btnW:CGFloat = 50
        let cityView = UIView.init(frame: CGRect.init(x: 0, y: 60, width: 100 + btnW * 3, height: 22))
        head.addSubview(cityView)
        cityView.center.x = head.center.x
        let arr = ["旧镇", "君临城", "瑞克城"]
        
        for (index,title) in arr.enumerated() {
        
            let btn = UIButton.init(frame: CGRect.init(x: (btnW + 50) * CGFloat(index), y: 0, width: btnW, height: 22))
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(UIColor.textBlack, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.addTarget(self, action: #selector(BSChooseAreaCtrl.tapCityButton(_:)), for: .touchUpInside)
            btn.tag = index + 10
            cityView.addSubview(btn)
        }
        
        return head
    }
    
    fileprivate func setupTitle(_ label:UILabel){
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.CCCCCC
    }
    
    @objc func tapCityButton(_ sender: UIButton) {
        
        topHeight.constant = topViewHeight
        self.addressInfo.provinceName = "爱乐之城"
        self.addressInfo.provinceId = "02"
        
        self.addressInfo.areaName = ""
        self.addressInfo.areaId = ""
        self.addressInfo.streetName = ""
        self.addressInfo.streetId = ""
        self.addressInfo.villageName = ""
        self.addressInfo.villageId = ""
        
        switch sender.tag {
        case 10:
            self.addressInfo.cityName = "旧镇"
            self.addressInfo.cityId = "05"
        case 11:
            self.addressInfo.cityName = "君临城"
            self.addressInfo.cityId = "06"
        case 12:
            self.addressInfo.cityName = "瑞克城"
            self.addressInfo.cityId = "01"
        default:
            break
        }
        listType = .area
        resetButtonTitle()
        setupButtonTitle()
        getAreasData(self.addressInfo.cityId)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BSChooseAreaCell", for: indexPath) as! BSChooseAreaCell
        
        let data = allArray[listType.rawValue][indexPath.section]
        
        let char = data.name.firstChar
        if indexPath.section > 0 && char == allArray[listType.rawValue][indexPath.section - 1].name.firstChar {
            
            cell.chartLabel.isHidden = true
        }else{
            cell.chartLabel.isHidden = false
        }
        cell.chartLabel.text = char
        cell.areaLabe.text = data.name
            
        if cell.areaLabe.text == showName {
            
            cell.backgroundColor = UIColor.ColorHex(hex: "F6FCFF")
            if let _ = cell.viewWithTag(111) as? UIImageView {
                
            }else{
                cell.addSubview(checkImg)
            }
        }else{
            
            cell.backgroundColor = UIColor.white
            if let img = cell.viewWithTag(111) as? UIImageView {
                img.removeFromSuperview()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        topHeight.constant = topViewHeight
        let data = allArray[listType.rawValue][indexPath.section]
        didChoose(listType, data: data)
        
    }
    
    fileprivate func didChoose(_ type:chooseListType, data:BSAreaModel) {
        
        switch type {
        case .province:
            self.addressInfo.provinceName = data.name
            self.addressInfo.provinceId = data.id
            
            self.addressInfo.cityName = ""
            self.addressInfo.cityId = ""
            self.addressInfo.areaName = ""
            self.addressInfo.areaId = ""
            self.addressInfo.streetName = ""
            self.addressInfo.streetId = ""
            self.addressInfo.villageName = ""
            self.addressInfo.villageId = ""
            
            
            listType = .city
            resetButtonTitle()
            setupButtonTitle()
            getAreasData(data.id)
            
        case .city:
            self.addressInfo.cityName = data.name
            self.addressInfo.cityId = data.id
            
            self.addressInfo.areaName = ""
            self.addressInfo.areaId = ""
            self.addressInfo.streetName = ""
            self.addressInfo.streetId = ""
            self.addressInfo.villageName = ""
            self.addressInfo.villageId = ""
            
            listType = .area
            resetButtonTitle()
            setupButtonTitle()
            getAreasData(data.id)
            
        case .area:
            self.addressInfo.areaName = data.name
            self.addressInfo.areaId = data.id
            
            self.addressInfo.streetName = ""
            self.addressInfo.streetId = ""
            self.addressInfo.villageName = ""
            self.addressInfo.villageId = ""
            
            listType = .street
            resetButtonTitle()
            setupButtonTitle()
            getAreasData(data.id)
            
        case .street:
            self.addressInfo.streetName = data.name
            self.addressInfo.streetId = data.id
            self.addressInfo.villageName = ""
            self.addressInfo.villageId = ""
            
            listType = .village
            resetButtonTitle()
            setupButtonTitle()
            getAreasData(data.id)
            
        case .village:
            self.addressInfo.villageName = data.name
            self.addressInfo.villageId = data.id
            closeAction(self)
        }
    }
    
    fileprivate func resetButtonTitle(){
        
        self.provinceBtn.setTitle(addressInfo.provinceName, for: .normal)
        self.cityBtn.setTitle(addressInfo.cityName, for: .normal)
        self.areaBtn.setTitle(addressInfo.areaName, for: .normal)
        self.streetBtn.setTitle(addressInfo.streetName, for: .normal)
    }
    
    fileprivate func setupButtonTitle(){
        
        for btn in buttonArray {
            btn.setTitleColor(UIColor.textBlack, for: .normal)
        }
        line.center.x = (SCREENWIDTH/4) * CGFloat(listType.rawValue) + (SCREENWIDTH/8)
        
        switch listType {
        case .province:
            self.provinceBtn.setTitleColor(UIColor.mainBlue, for: .normal)
            self.provinceBtn.setTitle(getReminderTitle(addressInfo.provinceName) , for: .normal)
            
        case .city:
            self.cityBtn.setTitleColor(UIColor.mainBlue, for: .normal)
            self.cityBtn.setTitle(getReminderTitle(addressInfo.cityName) , for: .normal)
            
        case .area:
            self.areaBtn.setTitleColor(UIColor.mainBlue, for: .normal)
            self.areaBtn.setTitle(getReminderTitle(addressInfo.areaName) , for: .normal)
            
        case .street:
            self.streetBtn.setTitleColor(UIColor.mainBlue, for: .normal)
            self.streetBtn.setTitle(getReminderTitle(addressInfo.streetName) , for: .normal)
            
        default:
            break
        }
    }
    
    fileprivate func getReminderTitle(_ title:String) -> String {
        
        return title == "" ? "请选择" : title
    }
    
    @IBAction func clickButtonAction(_ sender: Any) {
        
        guard let btn = sender as? UIButton, btn.title(for: .normal) != "" else{
            return
        }
        
        var theID = ""
        switch btn.tag {
        case 1:
            showName = addressInfo.provinceName
            listType = .province
            
        case 2:
            showName = addressInfo.cityName
            listType = .city
            theID = self.addressInfo.provinceId
            
        case 3:
            showName = addressInfo.areaName
            listType = .area
            theID = self.addressInfo.cityId
            
        case 4:
            showName = addressInfo.streetName
            listType = .street
            theID = self.addressInfo.areaId
            
        default:
            break
        }
        
        setupButtonTitle()
        getAreasData(theID)

    }
    
}
