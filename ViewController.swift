//
//  ViewController.swift
//  memoryGame
//
//  Created by Aitor Ballesteros on 20/10/2019.
//  Copyright © 2019 Aitor Ballesteros. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    var level = false
    
    var counter = 2
    
    public var levelNumber = 1
    
    @IBOutlet weak var levelButton: UILabel! //Level con referencia al nivel por el que vamos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Juego de memoria"
        
    }
    
    //Este método lo utilizamos para actualizar el label del nivel. ViewWillAppear aparece siempre que entremos en esta vista.
    
    override func viewWillAppear(_ animated: Bool) {
        levelButton.text = String(levelNumber)
        print("En que nivel vamos", levelNumber)
    }
    
    
    //Método para pasar lso datos de esta vista al CarruselView. Ademas de eso añadimos un booleano que le llega de la vista ShowImagesView para que solo se ejecute este codigo cuando sea true.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if level == true{
            let destVC = segue.destination as! CarruselView
            destVC.nextLevel = true
            destVC.numberImages = counter //Enviamos el contador de images para subir de nivel
            destVC.levelNumber = levelNumber
        }
    }
    
    //Este método hace referencia al unwind de la vista ShowImages. La razón de este método es para pasar los datos del unwind a esta vista. Así conseguimos actualizar los datos cuando el jugador pierda la partida. Funciona como un reseteo de los datos.
    @IBAction func unwindToMenu(segue: UIStoryboardSegue){
        if segue.source is ShowImagesController {
            if let segueVC = segue.source as? ShowImagesController{
                if segueVC.counterLost == 0 {
                    counter = 1 //recibimos el contador del ShowImages para actualizarlo a 1 y volver a pensar el juego desde el nivel más bajo
                    levelNumber = 1
                }
            }
        }
    }
    // Metodo para pasar a la pantalla del carrusel de imagenes.
    @IBAction func startGame(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toCarrusel" , sender: sender)
    }
}

