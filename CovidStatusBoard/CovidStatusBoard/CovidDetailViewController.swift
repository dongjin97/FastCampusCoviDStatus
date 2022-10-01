//
//  CovidDetailViewController.swift
//  CovidStatusBoard
//
//  Created by 원동진 on 2022/09/28.
//

import UIKit

class CovidDetailViewController: UITableViewController {

    
    @IBOutlet weak var newCaseCell: UITableViewCell!
    @IBOutlet weak var totalCaseCell: UITableViewCell!
    @IBOutlet weak var recoveredCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    @IBOutlet weak var regionalOutbreakCell: UITableViewCell!
    
    
    var covidOverview : CovidOverView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView(){
        guard let covidOverView = self.covidOverview else { return} //옵셔널 바인딩
        self.title = covidOverView.countryName
        self.newCaseCell .detailTextLabel?.text="\(covidOverView.newCase)명"
        self.totalCaseCell.detailTextLabel?.text="\(covidOverView.totalCase)명"
        self.recoveredCell.detailTextLabel?.text="\(covidOverView.recovered)명"
        self.deathCell.detailTextLabel?.text="\(covidOverView.death)명"
        self.percentageCell.detailTextLabel?.text="\(covidOverView.percentage)%"
        self.overseasInflowCell.detailTextLabel?.text="\(covidOverView.newFcase)명"
        self.regionalOutbreakCell.detailTextLabel?.text="\(covidOverView.newCcase)명"
    }
}
 
