//
//  WDExpandableTableView.swift
//  WDExpandableTableView
//
//  Created by Vladimir Dinic on 3/15/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

public enum ExpandableTableType
{
    case canExpandOnlyOne
    case canExpandAll
}

public protocol WDExpandableTableViewDelegate{
    func heightForParentCell(forParentAtIndex parentIndex:Int) -> CGFloat
    func heightForChildCell(atIndexPath indexPath:IndexPath) -> CGFloat
    func numberOfParentCells() -> Int
    func numberOfChildCells(forParentAtIndex parentIndex:Int) -> Int
    func parentCell(forParentAtIndex parentIndex:Int) -> UITableViewCell
    func childCell(atIndexPath indexPath:IndexPath) -> UITableViewCell
    func didSelectCell(atIndexPath indexPath:IndexPath)
    func expandableTableType() -> ExpandableTableType
}

open class WDExpandableTableView: UITableView, UITableViewDelegate, UITableViewDataSource, WDSubTableViewDelegate {
    
    private var visibleSection:Int?
    private var visibleSections:[Int]?
    
    open var delegateExpandable:WDExpandableTableViewDelegate! = nil
    
    override open func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        self.register(UINib(nibName: "SubTableCell", bundle: Bundle(for: SubTableCell.classForCoder())), forCellReuseIdentifier: "SubTableCell")
        
        visibleSections = [Int]()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return delegateExpandable.numberOfParentCells()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            return delegateExpandable.parentCell(forParentAtIndex: indexPath.section)
        }
        else
        {
            let cell:SubTableCell = tableView.dequeueReusableCell(withIdentifier: "SubTableCell", for: indexPath) as! SubTableCell
            cell.subTableDelegate = self
            cell.updateSubTable(forSubTableIndex: indexPath.section)
            cell.subTable.reloadData()
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return delegateExpandable.heightForParentCell(forParentAtIndex: indexPath.section)
        }
        else
        {
            if self.delegateExpandable.expandableTableType() == .canExpandAll
            {
                if let sections = visibleSections
                {
                    if sections.contains(indexPath.section)
                    {
                        var cellsTotalHeight:CGFloat = 0.0
                        let numberOfRows = self.delegateExpandable.numberOfChildCells(forParentAtIndex: indexPath.section)
                        if numberOfRows > 0
                        {
                            for i in 0...numberOfRows-1
                            {
                                cellsTotalHeight += self.delegateExpandable.heightForChildCell(atIndexPath: IndexPath(row: i, section: indexPath.section))
                            }
                        }
                        
                        return cellsTotalHeight
                    }
                    else
                    {
                        return 0
                    }
                }
                else
                {
                    return 0
                }
            }
            else
            {
                if indexPath.section == visibleSection
                {
                    var cellsTotalHeight:CGFloat = 0.0
                    let numberOfRows = self.delegateExpandable.numberOfChildCells(forParentAtIndex: indexPath.section)
                    if numberOfRows > 0
                    {
                        for i in 0...numberOfRows-1
                        {
                            cellsTotalHeight += self.delegateExpandable.heightForChildCell(atIndexPath: IndexPath(row: i, section: indexPath.section))
                        }
                    }
                    
                    return cellsTotalHeight
                }
                else
                {
                    return 0
                }
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            self.toggleSection(atIndex: indexPath.section)
        }
        else
        {
            delegateExpandable.didSelectCell(atIndexPath: IndexPath(row: indexPath.row-1, section: indexPath.section))
        }
    }
    
    func toggleSection(atIndex index:Int)
    {
        self.beginUpdates()
        if self.delegateExpandable.expandableTableType() == .canExpandAll
        {
            if var sections = visibleSections
            {
                var indexIsSelected = false
                var indexPosition = -1
                if sections.count > 0
                {
                    for i in 0...sections.count-1
                    {
                        if sections[i] == index
                        {
                            indexIsSelected = true
                            indexPosition = i
                            break
                        }
                    }
                }
                if indexIsSelected
                {
                    visibleSections!.remove(at: indexPosition)
                }
                else
                {
                    visibleSections!.append(index)
                }
            }
        }
        else
        {
            if visibleSection == index
            {
                visibleSection = -1
            }
            else
            {
                visibleSection = index
            }
        }
        self.endUpdates()
    }
    
    func subTableNumberOfChildCells(forParentAtIndex parentIndex: Int) -> Int {
        return delegateExpandable.numberOfChildCells(forParentAtIndex: parentIndex)
    }
    
    func subTableDidSelectCell(atIndexPath indexPath: IndexPath) {
        return delegateExpandable.didSelectCell(atIndexPath: indexPath)
    }
    
    func subTableHeightForChildCell(atIndexPath indexPath: IndexPath) -> CGFloat {
        return delegateExpandable.heightForChildCell(atIndexPath: indexPath)
    }
    
    func subTableCell(atIndexPath indexPath: IndexPath) -> UITableViewCell {
        return delegateExpandable.childCell(atIndexPath: indexPath)
    }

}
