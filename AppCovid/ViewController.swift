//
//  ViewController.swift
//  AppCovid
//
//  Created by Mac16 on 17/12/20.
//

import UIKit
import WebKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    let urlAPICovid = "https://corona.lmao.ninja/v3/covid-19/countries/"
    
    @IBOutlet weak var webViewBandera: WKWebView!
    @IBOutlet weak var labelFechaAct: UILabel!
    @IBOutlet weak var labelActivos: UILabel!
    @IBOutlet weak var labelRecuperados: UILabel!
    @IBOutlet weak var labelMortales: UILabel!
    @IBOutlet weak var labelConfirmados: UILabel!
    @IBOutlet weak var labelPais: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            buscarPorPais(pais: searchBar.text!.replacingOccurrences(of: "ñ", with: "n"))
        } else {
            mostrarAlerta(titulo: "Advertencia", mensaje: "No puedes dejar el campo vacío")
        }
        
    }
    
    
    
    func buscarPorPais(pais:String){
        let url = URL(string: "\(urlAPICovid)\(pais)")
        print(url?.absoluteURL)
        let peticion = URLRequest(url: url!)
        let tarea = URLSession.shared.dataTask(with: peticion){datos,respuesta,error in
            
            if error != nil {
                print(error!)
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    print(json)
                    self.actualizarGUI(json: json)
                } catch {
                    print("Error al convertir el json \(error)")
                }
            }
        }
        tarea.resume()
        
        
        
    }
    
    func actualizarGUI(json:AnyObject){
        if let message = json["message"] as? String{
            self.mostrarAlerta(titulo: "Advertencia", mensaje: "No se encontró el país")
            print(message)
        }else{
            let unixtimeInterval = (json["updated"] as! Double) / 1000
            let fechaActualizacion = formatoFecha(unixtimeInterval: unixtimeInterval)
            let nombrePais = json["country"] as! String
            let imgBandera = (json["countryInfo"] as! [String:Any])["flag"] as! String
            let casosConfirmados = formatoNumeros(numero:(json["cases"] as! Int))
            let casosMortales = formatoNumeros(numero: (json["deaths"] as! Int))
            let casosRecuperados = formatoNumeros(numero: (json["recovered"] as! Int))
            let casosActivos = formatoNumeros(numero: (json["recovered"] as! Int))
            
            DispatchQueue.main.async {
                self.labelPais.text = "Casos \(nombrePais)"
                self.labelActivos.text = "\(casosActivos) casos"
                self.labelMortales.text = "\(casosMortales) casos"
                self.labelRecuperados.text = "\(casosRecuperados) casos"
                self.labelConfirmados.text = "\(casosConfirmados) casos"
                self.labelFechaAct.text = fechaActualizacion
                self.webViewBandera.load(URLRequest(url: URL(string: imgBandera)!))
            }
        }
    }
    func formatoNumeros(numero:Int) -> String{
        if numero == 0 {
            return "Sin datos de"
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSize = 3
        let numero = numberFormatter.string(from: NSNumber(value: numero)) ?? "0"
        return numero
        
    }
    func formatoFecha(unixtimeInterval:Double) -> String {
        let date = Date(timeIntervalSince1970: unixtimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func mostrarAlerta(titulo:String, mensaje:String){
        DispatchQueue.main.async {
            
            let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
            let alertaAceptar = UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler:  nil)
            alerta.addAction(alertaAceptar)
            self.present(alerta, animated: true, completion:  nil)
        }
        
    }
    
        //Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


