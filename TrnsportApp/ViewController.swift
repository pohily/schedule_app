//
//  ViewController.swift
//  TrnsportApp
//
//  Created by Michael Pohily on 27.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btnBabka: UIButton!
    @IBOutlet weak var btnOstankino: UIButton!
    @IBOutlet weak var btnMedvedkovo: UIButton!
    @IBOutlet weak var btnOtradnoe: UIButton!
    @IBOutlet weak var btnAltufan: UIButton!
    
    let scheduler = Scheduler()
    
    
    @IBOutlet weak var segmentHome: UISegmentedControl!
    @IBAction func actionHome(_ sender: UISegmentedControl) {
        switch segmentHome.selectedSegmentIndex {
        case 0:
            scheduler.home = true
        case 1:
            scheduler.home = false
        default:
            scheduler.home = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func actionBabka(_ sender: Any) {
        let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        if scheduler.metro() != "" {
            secondVC.info = scheduler.metro()
        } else {
            secondVC.info = "Пока не едет"
        }
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @IBAction func actionOstankino(_ sender: Any) {
        let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        if scheduler.tram_ostankino() != "" {
            secondVC.info = scheduler.tram_ostankino()
        } else {
            secondVC.info = "Пока не едет"
        }
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @IBAction func actionMedvedkovo(_ sender: Any) {
        let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        if scheduler.tram_medvedkovo() != "" {
            secondVC.info = scheduler.tram_medvedkovo()
        } else {
            secondVC.info = "Пока не едет"
        }
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @IBAction func actionOtradnoe(_ sender: Any) {
        let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        if scheduler.otradnoe() != "" {
            secondVC.info = scheduler.otradnoe()
        } else {
            secondVC.info = "Пока не едет"
        }
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @IBAction func actionAltufan(_ sender: Any) {
        let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        if scheduler.altufan() != "" {
            secondVC.info = scheduler.altufan()
        } else {
            secondVC.info = "Пока не едет"
        }
        navigationController?.pushViewController(secondVC, animated: true)
    }
}
