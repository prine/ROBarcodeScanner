//
//  ViewController.swift
//  ROBarcodeScanner
//
//  Created by Robin Oster on 24/07/15.
//  Copyright (c) 2015 RASCOR International AG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var scanButton:UIButton!
    @IBOutlet var scanResult:UILabel!
    
    var barcodeScanner:ROBarcodeScannerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        barcodeScanner = self.storyboard!.instantiateViewControllerWithIdentifier("ROBarcodeScannerViewControllerScene") as? ROBarcodeScannerViewController

        // Do any additional setup after loading the view.
    }
    
    @IBAction func scanClicked() {
        barcodeScanner?.barcodeScanned = { (barcode:String) in
            self.navigationController?.popViewControllerAnimated(true)
            print("Received following barcode: \(barcode)")

            dispatch_async(dispatch_get_main_queue(),{
                self.scanResult.text = "\(barcode)"
            })
        }
        
        if let barcodeScanner = self.barcodeScanner {
            self.navigationController?.pushViewController(barcodeScanner, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
