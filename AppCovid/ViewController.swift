//
//  ViewController.swift
//  AppCovid
//
//  Created by Mac16 on 17/12/20.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    let urlAPICovid = "https://corona.lmao.ninja/v3/covid-19/countries/"

    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        buscarPorPais(pais: "Mexico")
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Botón buscar presionado")
        print(searchBar.text ?? "")
    }

    
        
    func buscarPorPais(pais:String){
        let peticion = URLRequest(url: URL(string: "\(urlAPICovid)\(pais)")!)
        let tarea = URLSession.shared.dataTask(with: peticion){datos,respuesta,error in
          
            if error != nil {
                print(error!)
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    print(json)
                } catch {
                    print(error)
                }
            }
        }
        tarea.resume()
        
        
        
    }
}


