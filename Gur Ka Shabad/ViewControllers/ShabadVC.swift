//
//  ShabadVC.swift
//  Speech Recognization
//
//  Created by Admin on 18/09/18.
//  Copyright © 2018 anamcorp. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShabadVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer()
    }
}

extension ShabadVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shabadList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cell
        
        let shabad = shabadList[indexPath.row]["shabad"]
        
        let english = shabadList[indexPath.row]["shabad"]["translation"]["english"]["default"].stringValue
        
        let gaumukhi = shabad["gurmukhi"]
        let unicod = gaumukhi["unicode"].rawString()
                
        cell.punjabiTxt.text = unicod
        cell.englishTxt.text = english
        
        guard let punjabi = shabadList[indexPath.row]["shabad"]["translation"]["punjabi"]["default"]["unicode"].string else {
            return cell
        }
        
        cell.punjabiMeaningTxt.text = punjabi
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = storyboard?.instantiateViewController(withIdentifier: "AllShabadVC") as! AllShabadVC
        let shabad = shabadList[indexPath.row]["shabad"]
        vc.shabadID = shabad["shabadid"].stringValue
        //present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}
