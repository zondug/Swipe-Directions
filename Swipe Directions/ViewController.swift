//
//  ViewController.swift
//  Swift Directions
//
//  Created by Zondug Kim on 2017. 9. 18..
//  Copyright © 2017년 Zondug Kim. All rights reserved.
//
//  Some codes from 'MagicalGrid' created by Brian Voong


import UIKit

class ViewController: UIViewController {
	
	var cells = [String: UIView]()
	var cellview: UIView!
	var textlabel: UILabel!
	var zoomcell: UIView!
	
	var noOfCells: Int = 5
	var cellsize: Int = 50
	var spacing: Int = 5
	
	var firstLocation: CGPoint?
	var secondLocation: CGPoint?
	
	enum targetcell: String {
		case center = "2|2"
		case north = "2|1"
		case northeast = "3|1"
		case east = "3|2"
		case southeast = "3|3"
		case south = "2|3"
		case southwest = "1|3"
		case west = "1|2"
		case northwest = "1|1"
	}
	
	var _key: String = targetcell.center.rawValue
	var key: String? {
		get {
			return _key
		}
		set(newVal) {
			returnCell(key: key!)
			_key = newVal!
			zoomedCell(key: _key)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let centering: Int = Int(view.frame.width)/2 - (noOfCells * cellsize + (spacing * 4))/2
		
		for rows in 0...(noOfCells-1) {
			for cols in 0...(noOfCells-1) {
				
				let cellView = UIView()
				
				cellView.frame = CGRect(x: centering + (rows * cellsize) + (spacing * rows), y: 100 + (cols * cellsize) + (spacing * cols), width: cellsize, height: cellsize)
				cellView.backgroundColor = randomColor()
				
				textlabel = UILabel(frame: cellView.bounds)
				textlabel.textAlignment = .center
				textlabel.text = "\(rows, cols)"
				
				cellView.addSubview(textlabel)
				
				cellView.layer.borderWidth = 2
				cellView.layer.borderColor = UIColor.gray.cgColor
				cellView.bringSubview(toFront: textlabel)
				view.addSubview(cellView)
				
				let key = "\(rows)|\(cols)"
				cells[key] = cellView
			}
		}
		
		view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipes)))
	}
	
	func swipes(swiped: UIPanGestureRecognizer) {

		let dragged = swiped.translation(in: view)
		
		var angle =  Double(atan2f(Float(dragged.y), Float(dragged.x))) * (360 / (2 * Double.pi))
		
		if (angle < 0) {
			angle = angle + 360
		}
		
		var distance: CGFloat = 0.0
		let defaultDistance: CGFloat = 20.0
		let maximumDistance: CGFloat = 150
		
		switch swiped.state {
		case .began:
			firstLocation = swiped.location(in: view)
			key = targetcell.center.rawValue
			
		case .changed:
			secondLocation = swiped.location(in: view)
			
			let dx = (secondLocation?.x)! - (firstLocation?.x)!
			let dy = (secondLocation?.y)! - (firstLocation?.y)!
			distance = sqrt(dx*dx + dy*dy)
			
			if distance < defaultDistance {

				key = targetcell.center.rawValue
				
			} else if defaultDistance < distance && distance < maximumDistance {

				switch angle {
				case 22.5 ..< 67.5:
					key = targetcell.southeast.rawValue
				case 67.5 ..< 112.5:
					key = targetcell.south.rawValue
				case 112.5 ..< 157.5:
					key = targetcell.southwest.rawValue
				case 157.5 ..< 202.5:
					key = targetcell.west.rawValue
				case 202.5 ..< 237.5:
					key = targetcell.northwest.rawValue
				case 237.5 ..< 292.5:
					key = targetcell.north.rawValue
				case 292.5 ..< 337.5:
					key = targetcell.northeast.rawValue
				case 337.5 ..< 360, 0 ..< 22.5:
					key = targetcell.east.rawValue
				default: break
				}
				
			}  else  {
				return
			}

//			cells[key!]?.backgroundColor = UIColor.black
//			print(distance, angle)
			
		case .ended:
//			excuteCellCard()
			return
			
		default:
			break
		}
	}
	
	func zoomedCell(key: String) -> UIView {
		
		zoomcell = cells[key]
		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.zoomcell?.layer.transform = CATransform3DIdentity
			self.zoomcell?.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2)
		}, completion: nil)
		
		return zoomcell
	}
	
	func returnCell(key: String) -> UIView {

		zoomcell = cells[key]

		UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
			self.zoomcell?.layer.transform = CATransform3DIdentity
		}, completion: { (_) in})

		return zoomcell
	}
	
	func randomColor() -> UIColor {
		let red = CGFloat(drand48())
		let green = CGFloat(drand48())
		let blue = CGFloat(drand48())
		return UIColor(red: red, green: green, blue: blue, alpha: 1)
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

