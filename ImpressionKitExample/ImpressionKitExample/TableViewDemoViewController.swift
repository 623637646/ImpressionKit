//
//  TableViewDemoViewController.swift
//  ImpressionKitExample
//
//  Created by Yanni Wang on 6/6/21.
//

import UIKit
import ImpressionKit

class TableViewDemoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = { () -> UITableView in
        let view = UITableView.init()
        view.backgroundColor = .white
        view.register(Cell.self, forCellReuseIdentifier: "Cell")
        return view
    }()

    lazy var group = ImpressionGroup.init {(_, index: IndexPath, view, state) in
        if state.isImpressed {
            print("impressed index: \(index.row)")
        }
        if let cell = view as? Cell {
            cell.updateUI(state: state)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem.init(title: "nextPage", style: .plain, target: self, action: #selector(nextPage)),
            UIBarButtonItem.init(title: "redetect", style: .plain, target: self, action: #selector(redetect)),
        ]
        
        self.tableView.frame = CGRect(x: 0,
                                 y: view.frame
                                     .height * CGFloat(HomeViewController.viewHeightRatio) *
                                     (HomeViewController.viewHeightRatio == 1 ? 0 : 0.5),
                                 width: view.frame.width, height: view.frame.height * CGFloat(HomeViewController.viewHeightRatio))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }

    @objc private func redetect() {
        self.group.redetect()
    }

    @objc private func nextPage() {
        let nextPage = UIViewController()
        nextPage.view.backgroundColor = .white
        self.navigationController?.pushViewController(nextPage, animated: true)
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 99
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        cell.index = indexPath.row
        cell.updateUI(state: self.group.states[indexPath])
        self.group.bind(view: cell, index: indexPath)
        return cell
    }
    
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}

private class Cell: UITableViewCell {
    private var label = { () -> UILabel in
        let view = UILabel.init()
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .black
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    var index: Int = -1
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.layer.borderColor = UIColor.gray.cgColor
        self.contentView.layer.borderWidth = 0.5
        self.contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = self.contentView.bounds
    }
    
    fileprivate func updateUI(state: UIView.State?) {
        self.layer.removeAllAnimations()
        switch state {
        case .impressed(_, let areaRatio):
            self.label.text = String.init(format: "\(self.index)\n%0.1f%%", areaRatio * 100)
            self.contentView.backgroundColor = .green
        case .inScreen(_):
            self.contentView.backgroundColor = .white
            UIView.animate(withDuration: TimeInterval(self.durationThreshold ?? UIView.durationThreshold), delay: 0, options: [.curveLinear, .allowUserInteraction], animations: {
                self.contentView.backgroundColor = .red
            }, completion: nil)
        default:
            self.label.text = "\(self.index)\n"
            self.contentView.backgroundColor = .white
        }
    }
}
