//
//  AllShabadVC.swift
//  Speech Recognization
//
//  Created by Admin on 18/09/18.
//  Copyright © 2018 anamcorp. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AllShabadVC: UIViewController {
    
    var shabadID : String = "" //https://api.gurbaninow.com/v2/shabad/ 2154
    var list : [JSON] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getShabdas(shabadID: shabadID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer()
    }
    
    func getShabdas(shabadID:String) {
        showLoader()
        Alamofire.request(URL(string: baseUrl + "shabad/"  + shabadID + "/?source=G")!, method: .get, parameters : nil)
            .responseJSON { response in
                self.hideLoader()
                switch response.result {
                case .success(let value) :
                    let json = JSON(value)
                    self.list = json["shabad"].arrayValue
                    self.printResponseDicionary(response: response)
                    self.tableView.reloadData()
                    break
                case .failure(let error) :
                    print(error.localizedDescription)
                    break
                }
        }
    }
    
}

extension AllShabadVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cell
        
        let shabad = list[indexPath.row]["line"]
        let gaumukhi = shabad["gurmukhi"]
        let unicod = gaumukhi["unicode"].rawString()
        
        let english = list[indexPath.row]["line"]["translation"]["english"]["default"].stringValue
        
        cell.punjabiTxt.text = unicod
        cell.englishTxt.text = english
        
        guard let punjabi = list[indexPath.row]["line"]["translation"]["punjabi"]["default"]["unicode"].string else {
            return cell
        }
        
        cell.punjabiMeaningTxt.text = punjabi
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
