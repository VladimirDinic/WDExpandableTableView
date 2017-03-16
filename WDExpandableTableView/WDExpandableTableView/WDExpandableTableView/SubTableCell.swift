//
//  SubTableCell.swift
//  WDExpandableTableView
//
//  Created by Vladimir Dinic on 3/15/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

protocol WDSubTableViewDelegate{
    func subTableHeightForChildCell(atIndexPath indexPath:IndexPath) -> CGFloat
    func subTableNumberOfChildCells(forParentAtIndex parentIndex:Int) -> Int
    func subTableDidSelectCell(atIndexPath indexPath:IndexPath)
    func subTableCell(atIndexPath indexPath:IndexPath) -> UITableViewCell
}

class SubTableCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var subTable: UITableView!
    
    var subTableParentIndex:Int?
    var subTableDelegate:WDSubTableViewDelegate! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateSubTable(forSubTableIndex subTableIndex:Int)
    {
        subTableParentIndex = subTableIndex
        self.subTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let wdDelegate = subTableDelegate, let section = subTableParentIndex
        {
            return wdDelegate.subTableCell(atIndexPath: IndexPath(row: indexPath.row, section: section))
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let wdDelegate = subTableDelegate, let section = subTableParentIndex
        {
            wdDelegate.subTableDidSelectCell(atIndexPath: IndexPath(row: indexPath.row, section: section))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let wdDelegate = subTableDelegate, let section = subTableParentIndex
        {
            return wdDelegate.subTableNumberOfChildCells(forParentAtIndex: section)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let wdDelegate = subTableDelegate, let section = subTableParentIndex
        {
            return wdDelegate.subTableHeightForChildCell(atIndexPath: IndexPath(row: indexPath.row, section: section))
        }
        return 0
    }
    
}
