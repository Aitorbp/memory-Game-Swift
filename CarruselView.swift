//
//  CarruselView.swift
//  memoryGame
//
//  Created by Aitor Ballesteros on 26/10/2019.
//  Copyright © 2019 Aitor Ballesteros. All rights reserved.
//


import UIKit

class CarruselView: UIViewController {
    
    @IBOutlet weak var imageCarrusel: UIImageView!
    
    var images = [UIImage]()
    var timeInterval = 2.7 //Tiempo que dura la aplicación
    var timer: Timer? //Variable de Timer para crear la aplicación
    var myImagesFixes : ArraySlice<String> // Imágenes random que tenemos que analizar
        = []
    var numberImages = 2 //Número de imágenes que te muestran la animación en el nivel 1
    var nextLevel = false //Variable que valida el siguiente nivel
    
    var levelNumber = 1 //Nivel por defecto del videojuego
    
    //Boton para ir a la pantalla ShowImagesController
    @IBAction func goToGallery(_ sender: UIButton) {
        performSegue(withIdentifier: "showGallery", sender: sender)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //En este array guardamos las imágenes que vamos a mostrar al jugador de forma secuencial
       
        
        var myImages = ["1","2","3","4","5","6","7","8","9","10","11","12"]
        
        //Ejecutamos el método shufle() para cambair las fotos de sitio. Funcioa como un Random
        myImages.shuffle()
        
        print("next level is \(nextLevel)")
        print("máximo de images", numberImages)
        //Validacion para subir de nivel. El true se lo pasamos por la pantalla de ShowImages
        if nextLevel == true && numberImages <= 3{
            numberImages = numberImages + 1
            print("numero de images \(numberImages)")
        }
        
        //Una vez descolocadas las imágenes cortamos el array por el número de imágenes que queremos mostar al usuario. El número de imaágenes cambiará en función del nivel en que nos encontremos.
        myImagesFixes =  myImages.prefix(numberImages)
        
        //Creamos un array alternativo para meter las fotos aleatorías y creal animación
        var images = [UIImage]()
        
        //Hacemos un for para recorrer las imagenes
        for i in 0..<myImagesFixes.count{
            images.append(UIImage(named:myImagesFixes[i])!)        }
        
        
        imageCarrusel.animationImages = images
        imageCarrusel.animationDuration = timeInterval //Establecemos el intervalo de tiempo que queremos que dure la animación
        imageCarrusel.startAnimating()
        imageCarrusel.layer.borderColor = UIColor.white.cgColor
        imageCarrusel.layer.borderWidth = 1
        imageCarrusel.layer.cornerRadius = 5
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateTime), userInfo: nil, repeats: false)
        
    }
    
    //Esta función ejecuta la funcionalidad de la animación, que se añade en el selector del Timer.
    @objc func updateTime(){
        if timeInterval > 0.40{
            timeInterval = timeInterval - 0.02
            imageCarrusel.animationDuration = timeInterval
            imageCarrusel.stopAnimating()
            imageCarrusel.layer.borderColor = UIColor.clear.cgColor //Ponemos el color a clear para que cuando termine la aplicación se quite el borde
            timer?.invalidate()
            timer = nil
        }
    }
    
    //Método que envía los datos al showImages Controller. Envia el número de imágenes y el nivel el que estamos.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGallery"{
            let destVC = segue.destination as? ShowImagesController
            destVC?.imageFixes = myImagesFixes
            if nextLevel == true {
                destVC?.counter = numberImages
                nextLevel = false
                destVC?.numberLvl = levelNumber
            }
        }
    }
}
