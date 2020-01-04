//
//  ShowImagesController.swift
//  memoryGame
//
//  Created by Aitor Ballesteros on 20/10/2019.
//  Copyright © 2019 Aitor Ballesteros. All rights reserved.
//


import UIKit

class ShowImagesController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var selectedIndex:IndexPath?
    
    var images:[String] = ["1","2","3","4","5","6","7","8","9","10","11","12"] //Array de imágenes ara visualizar en el collection
    var selectedImagesCorrect: ArraySlice <String> = [] //Array de imágenes correctas seleccionadas por el jugador
    var selectedImages: ArraySlice <String> = [] // Array de imáganes seleccionadas.
    var imageFixes : ArraySlice <String> = [] //Array con las imaganes correctas
    var isTrue: Bool = false // Booleano para validar que los datos se pasen a otro nivel cuando se complete el nivel
    var counter = 2
    var counterLost = 3 //Número de intentos que tienes para NO perder la partida
    var numberLvl = 1 //Nivel en el que empieza el juego
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var goodImages: UICollectionView!
    
    @IBOutlet weak var numberOfAttempt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myCollectionView.dataSource = self
        self.myCollectionView.delegate = self
        self.goodImages.dataSource = self
        self.goodImages.delegate = self
        
        images.shuffle()
    }
    
    //Con este método accedemos a la celda seleccionada cuando clicamos. Dentro de este método añadimos toda la lógica de selección de celdas.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let itemSelected = images[indexPath.row]
        
        print("Imprimimos el \(itemSelected)")
        
        print("Imprmimos imagen seleccionada antes de comparar\(selectedImagesCorrect)")
        
        if imageFixes.contains(itemSelected) && !selectedImages.contains(itemSelected){
            print("Igual...")
            selectedImages.append(itemSelected)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MyCell
            //METEMOS LAS FOTOS QUE SON CORRECTAS
            selectedImagesCorrect.append(itemSelected)
            
            
            goodImages.reloadData()// reload del Collection goodImages para recargar los datos
            //OCULTAMOS LAS FOTOS QUE HAYAMOS ACEPTADO
            let selectCell = collectionView.cellForItem(at: indexPath) as? MyCell
            selectCell?.myImageView.isHidden = true
            
            print("Seleccionadas correctas",selectedImagesCorrect)
            
            print("La foto es la correcta \(selectedImagesCorrect)")
            isTrue = true
            //Ordenamos las imagenes para que coincidan los índices y no de errores en los contadores.
            if imageFixes.sorted().elementsEqual(selectedImagesCorrect.sorted()) {
                
                let alert = UIAlertController(title: "Enhorabuena!", message:"Has ganado el juego", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    (_)in
                    self.performSegue(withIdentifier: "unwindToMenu", sender: self)
                })
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            }
            print("counter: \(counter)")
            
        }
        else if !imageFixes.contains(itemSelected){
            
            counterLost = counterLost - 1
            print("vidas menos\(counterLost)")
            
            self.numberOfAttempt.text = String(counterLost)
            print("Numero de intentos que te quedan\(numberOfAttempt)")
            
            if counterLost == 0 {
                let alert = UIAlertController(title: "Has perdido!", message:"Inténtalo de nuevo", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    (_)in
                    self.performSegue(withIdentifier: "unwindToMenu", sender: self)
                })
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        print(selectedImages)
        print(itemSelected)
    }
    //Método para pasar los datos del siguiente nivel a la pantalla principal
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isTrue == true{
            let destVC = segue.destination as! ViewController
            destVC.level = true
            destVC.counter = counter
            destVC.levelNumber = numberLvl + 1
        }
    }
    
    // Método para contar el número de elementos en el array del collecion view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == goodImages{
            print("En el momento de contar\(selectedImages)")
            return selectedImagesCorrect.count
        }
        else{
            return images.count
        }
    }
    
    // En este método se pintan las celdas. Pero a través de un if le indicamos a que collection estamos haciendo referencia y así se ejecuta correctamente.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == myCollectionView){
            let cell = self.myCollectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MyCell
            cell.myImageView.image = UIImage(named: images[indexPath.row])
            cell.layer.borderColor = UIColor.red.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 5
            return cell
        }else{
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "goodImages", for: indexPath ) as! GoodImages
            cell2.myGoodImages.image = UIImage(named: selectedImagesCorrect[indexPath.row])
            
            cell2.layer.borderColor = UIColor.white.cgColor
            cell2.layer.borderWidth = 1
            cell2.layer.cornerRadius = 5
            return cell2
        }
    }
}
