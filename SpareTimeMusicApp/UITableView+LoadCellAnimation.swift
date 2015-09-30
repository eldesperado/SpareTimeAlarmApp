//
//  UITableView+LoadCellAnimation.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 9/4/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

struct UITableViewCellLoadingAnimations {
    // MARK: Enum
    enum AnimationCellDirection {
        case DropDownFromTop
        case LiftUpFromBottom
        case FromRightToLeft
        case FromLeftToRight
    }
}

extension UITableView {
    
    typealias AnimateCellLoadingClosure = () -> ()
    
    // MARK: Animating TableViewCell Function
    func reloadDataWithAnimation(direction: UITableViewCellLoadingAnimations.AnimationCellDirection, animationTime: NSTimeInterval, interval: NSTimeInterval) {
        self.setContentOffset(self.contentOffset, animated: false)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.hidden = true
            self.reloadData()
            }) { (finished) -> Void in
                self.hidden = false
                self.visibleRowsBeginAnimation(direction, animationTime: animationTime, interval: interval)
        }
    }

    func visibleRowsBeginAnimation(direction: UITableViewCellLoadingAnimations.AnimationCellDirection, animationTime:NSTimeInterval, interval:NSTimeInterval) {
        let visibleArray : NSArray = self.indexPathsForVisibleRows! as NSArray
        let count =  visibleArray.count
        
        switch (direction) {
        case .DropDownFromTop:
            for i in 0...(count-1){
                let path : NSIndexPath = visibleArray.objectAtIndex(count - 1 - i) as! NSIndexPath
                let cell : UITableViewCell = self.cellForRowAtIndexPath(path)!
                cell.hidden = true
                let originPoint : CGPoint = cell.center
                cell.center = CGPointMake(originPoint.x, originPoint.y - 1000)
                UIView.animateWithDuration(animationTime + NSTimeInterval(i) * interval, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    cell.center = CGPointMake(originPoint.x ,  originPoint.y + 2.0)
                    cell.hidden = false
                    }, completion: { (finished) -> Void in
                        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                            cell.center = CGPointMake(originPoint.x ,  originPoint.y - 2.0)
                            }, completion: { (finished) -> Void in
                                UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                                    cell.center = originPoint
                                    }, completion: { (finished) -> Void in
                                        
                                })
                        })
                        
                })
            }
        case .LiftUpFromBottom:
            for i in 0...(count-1){
                let path : NSIndexPath = visibleArray.objectAtIndex(i) as! NSIndexPath
                let cell : UITableViewCell = self.cellForRowAtIndexPath(path)!
                cell.hidden = true
                let originPoint : CGPoint = cell.center
                cell.center = CGPointMake(originPoint.x, originPoint.y + 1000)
                UIView.animateWithDuration(animationTime + NSTimeInterval(i) * interval, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    cell.center = CGPointMake(originPoint.x ,  originPoint.y - 2.0)
                    cell.hidden = false
                    }, completion: { (finished) -> Void in
                        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                            cell.center = CGPointMake(originPoint.x ,  originPoint.y + 2.0)
                            }, completion: { (finished) -> Void in
                                UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                                    cell.center = originPoint
                                    }, completion: { (finished) -> Void in
                                        
                                })
                        })
                })
            }
        case .FromLeftToRight:
            for i in 0...(count-1){
                let path : NSIndexPath = visibleArray.objectAtIndex(i) as! NSIndexPath
                let cell : UITableViewCell = self.cellForRowAtIndexPath(path)!
                cell.hidden = true
                let originPoint : CGPoint = cell.center
                cell.center = CGPointMake(-cell.frame.size.width,  originPoint.y)
                UIView.animateWithDuration(animationTime + NSTimeInterval(i) * interval, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    cell.center = CGPointMake(originPoint.x - 2.0,  originPoint.y)
                    cell.hidden = false;
                    }, completion: { (finished) -> Void in
                        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                            cell.center = CGPointMake(originPoint.x + 2.0,  originPoint.y)
                            }, completion: { (finished) -> Void in
                                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                                    cell.center = originPoint
                                    }, completion: { (finished) -> Void in
                                        
                                })
                        })
                })
            }
        case .FromRightToLeft:
            for i in 0...(count-1){
                let path : NSIndexPath = visibleArray.objectAtIndex(i) as! NSIndexPath
                let cell : UITableViewCell = self.cellForRowAtIndexPath(path)!
                cell.hidden = true
                let originPoint : CGPoint = cell.center
                cell.center = CGPointMake(cell.frame.size.width * 3.0,  originPoint.y)
                UIView.animateWithDuration(animationTime + NSTimeInterval(i) * interval, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    cell.center = CGPointMake(originPoint.x + 2.0,  originPoint.y)
                    cell.hidden = false;
                    }, completion: { (finished) -> Void in
                        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                            cell.center = CGPointMake(originPoint.x - 2.0,  originPoint.y)
                            }, completion: { (finished) -> Void in
                                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                                    cell.center = originPoint
                                    }, completion: { (finished) -> Void in
                                        
                                })
                        })
                })
                
            }
        }
    }
    
}
