//
//  ViewController.swift
//  TrnsportApp
//
//  Created by Michael Pohily on 27.02.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var switchHome: UISwitch!
    @IBOutlet weak var labelHome: UILabel!
    @IBOutlet weak var btnBabka: UIButton!
    @IBOutlet weak var btnOstankino: UIButton!
    @IBOutlet weak var btnMedvedkovo: UIButton!
    @IBOutlet weak var btnOtradnoe: UIButton!
    @IBOutlet weak var btnAltufan: UIButton!
    
    let scheduler = Scheduler()
    
    
    @IBAction func actionHome(_ sender: Any) {
        if switchHome.isOn {
            labelHome.text = "Я дома"
            scheduler.home = true
        } else {
            labelHome.text = "Я на остановке"
            scheduler.home = false
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
        if scheduler.tram() != "" {
            secondVC.info = scheduler.tram()
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
