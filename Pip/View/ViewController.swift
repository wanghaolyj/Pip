//
//  ViewController.swift
//  Pip
//
//  Created by 王浩 on 2024/12/2.
//

import UIKit

class ViewController: UIViewController {

    private let list:[TableViewCellType] = [.one, .two, .oneMoreThing]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "画中画"
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch list[indexPath.row] {
        case .one:
            self.navigationController?.pushViewController(SystemViewController(), animated: true)
        case .two:
            self.navigationController?.pushViewController(CustomPlayViewController(), animated: true)
        case .oneMoreThing:
            self.navigationController?.pushViewController(MoreViewController(), animated: true)
        }
    }
}

enum TableViewCellType {
    case one
    case two
    case oneMoreThing
    
    var name:String {
        switch self {
        case .one:
            return "AVPlayerViewController实现"
        case .two:
            return "AVPlayer实现"
        case .oneMoreThing:
            return "更多的事情"
        }
    }
}

