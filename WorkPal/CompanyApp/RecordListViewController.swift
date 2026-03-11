//
//  RecordListViewController.swift
//  iOS-188Asia
//
//  Created by Pat Chang (XN-188Asia) on 2025/1/14.
//

import UIKit

class RecordListViewController: UIViewController {

    @IBOutlet weak var recordListTableView: UITableView! {
        didSet {
            recordListTableView.register(with: RecordListTableViewCell.self)
        }
    }
    
    var records: Array<TimeRecord> = [] {
        didSet {recordListTableView.reloadData()}
    }
    
    var monthString = Date().toString(dateFormat: .month)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        
    }
    
    func fetchData() {
        CompanyDataManger.shared.fetch(month: monthString){
            self.records = $0
        }
    }
    

}

extension RecordListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let RecordListTableViewCell = tableView.dequeueReusableCell(with: RecordListTableViewCell.self, for: indexPath).bind(data: records[indexPath.row])
        
        return RecordListTableViewCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}


