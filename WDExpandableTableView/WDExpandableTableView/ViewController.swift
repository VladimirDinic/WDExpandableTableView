//
//  ViewController.swift
//  WDExpandableTableView
//
//  Created by Vladimir Dinic on 3/15/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WDExpandableTableViewDelegate {
    
    @IBOutlet weak var myExpandableTableView: WDExpandableTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myExpandableTableView.delegateExpandable = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfParentCells() -> Int {
        return 5
    }
    
    func numberOfChildCells(forParentAtIndex parentIndex: Int) -> Int {
        return parentIndex+1;
    }
    
    func parentCell(forParentAtIndex parentIndex: Int) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell()
        cell.backgroundColor = UIColor.black
        cell.selectionStyle = .none
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = "Category \(parentIndex+1)"
        return cell
    }
    
    func childCell(atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.myExpandableTableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.selectionStyle = .none
        let mod = indexPath.row % 3
        switch mod {
        case 0:
            cell.backgroundColor = UIColor.blue
        case 1:
            cell.backgroundColor = UIColor.yellow
        default:
            cell.backgroundColor = UIColor.green
        }
        return cell
    }
    
    func heightForParentCell(forParentAtIndex parentIndex: Int) -> CGFloat {
        return 80
    }
    
    func heightForChildCell(atIndexPath indexPath: IndexPath) -> CGFloat {
        let mod = indexPath.row % 3
        switch mod {
        case 0:
            return 40
        case 1:
            return 60
        default:
            return 50
        }
    }
    
    func didSelectCell(atIndexPath indexPath: IndexPath) {
        print("selected cell for parent index \(indexPath.section) and child index \(indexPath.row)")
    }
    
    func expandableTableType() -> ExpandableTableType {
        return .canExpandAll
    }

}

