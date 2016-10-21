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
        
        barcodeScanner = self.storyboard!.instantiateViewController(withIdentifier: "ROBarcodeScannerViewControllerScene") as? ROBarcodeScannerViewController
    }
    
    @IBAction func scanClicked() {
        
        // Define the callback which is executed when the barcode has been scanned
        barcodeScanner?.barcodeScanned = { (barcode:String) in
            
            // When the screen is tapped, return to first view (barcode is beeing passed as param)
            _ = self.navigationController?.popViewController(animated: true)
            print("Received following barcode: \(barcode)")

           DispatchQueue.main.async {
                self.scanResult.text = "\(barcode)"
            }
        }

        // Push the ViewController when you want to scan something
        if let barcodeScanner = self.barcodeScanner {
            self.navigationController?.pushViewController(barcodeScanner, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
