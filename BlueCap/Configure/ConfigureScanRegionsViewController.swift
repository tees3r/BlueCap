//
//  ConfigureScanRegionsViewController.swift
//  BlueCap
//
//  Created by Troy Stribling on 8/30/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//
import UIKit
import BlueCapKit
import CoreLocation

class ConfigureScanRegionsViewController : UITableViewController {
    
    struct MainStoryboard {
        static let configureScanRegionsCell     = "ConfigureScanRegionsCell"
        static let configureAddScanRegionSegue  = "ConfigureAddScanRegion"
    }
    
    required init(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Scan Regions"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    @IBAction func addRegion(sender:AnyObject) {
        let progressView = ProgressView()
        progressView.show()
        LocationManager.sharedInstance().startUpdatingLocation() {(locationManager) in
            locationManager.locationsUpdateSuccess = {(locations:[CLLocation]) in
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                if let location = locations.last {
                    Logger.debug("location update received: \(location)")
                    locationManager.stopUpdatingLocation()
                    progressView.remove()
                }
            }
            locationManager.locationsUpdateFailed = {(error:NSError!) in
                progressView.remove()
                self.presentViewController(UIAlertController.alertOnError(error), animated:true, completion:nil)
            }
        }
    }
    
    // UITableViewDataSource
    override func numberOfSectionsInTableView(tableView:UITableView!) -> Int {
        return 1
    }
    
    override func tableView(_:UITableView!, numberOfRowsInSection section:Int) -> Int {
        return ConfigStore.getScanRegions().count
    }
    
    override func tableView(tableView: UITableView!, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func tableView(tableView:UITableView!, commitEditingStyle editingStyle:UITableViewCellEditingStyle, forRowAtIndexPath indexPath:NSIndexPath!) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Fade)
        }
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath:NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.configureScanRegionsCell, forIndexPath: indexPath) as UITableViewCell
        let regions = Array(ConfigStore.getScanRegions().keys)
        cell.textLabel.text = regions[indexPath.row]
        return cell
    }
    
    // UITableViewDelegate
    
}