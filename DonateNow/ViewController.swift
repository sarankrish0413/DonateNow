//
//  ViewController.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 1/26/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    //Login Button action
    @IBAction func loginAction(_ sender: Any) {
//        let donorViewController = self.storyboard?.instantiateViewController(withIdentifier: "DonorViewController") as! DonorViewController
//        self.navigationController?.pushViewController(donorViewController, animated: true)
//        
//        
//        let vc: UINavigationController = segue.destinationViewController as! UINavigationController
//        let detailVC = vc.topViewController as! PatternDetailViewController
        
        self.performSegue(withIdentifier:"DonorViewController",sender: self)


        
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DonorViewController") {
           // let secondViewController  = segue.destination as! DonorViewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

