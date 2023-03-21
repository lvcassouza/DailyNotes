//
//  anotacao.swift
//  Notas Diarias
//
//  Created by Lucas Souza on 21/09/22.
//

import UIKit
import CoreData

class anotacao: UIViewController {

    @IBOutlet weak var texto: UITextView!
    var context: NSManagedObjectContext!
    var anotacao: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //configuracoes iniciais
        
        //para aparecer o teclado de primeira(sem clicar na tela)
        self.texto.becomeFirstResponder()
        
        
        if anotacao != nil {//atualizar
            let textoRecuperado = anotacao.value(forKey: "texto")
            //apaga todo texto pre config em Main
            self.texto.text = (textoRecuperado as! String)
            
            
        }else{
            
            //apaga todo texto pre config em Main
            self.texto.text = ""
            
        }
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    
    @IBAction func salvar(_ sender: Any) {
        
        if anotacao != nil{//atualizar
            
            self.atualizarAnotacao()
            
        }else{
            
            self.salvarAnotacao()
            
        }
        
        //retorna para tela principal
        self.navigationController?.popToRootViewController(animated: true)
        
    }

        //cria objeto para anotacao
        func salvarAnotacao (){
            
            let novaAnotacao = NSEntityDescription.insertNewObject(forEntityName: "Anotacao", into: context)
            
            //configura anotacao
            novaAnotacao.setValue(self.texto.text, forKey: "texto")
            novaAnotacao.setValue(Date(), forKey: "data")
            
            do{
                try context.save()
                print("Sucesso ao salvar!")
            } catch let erro {
                print("Erro ao salvar alteração: \(erro.localizedDescription)")
            }
            
        }
    //salvar atualizacao
    func atualizarAnotacao() {
        
        anotacao.setValue(self.texto.text, forKey: "texto")
        anotacao.setValue( Date(), forKey: "data")
        
        do{
            try context.save()
            print("Sucesso ao salvar!")
        } catch let erro {
            print("Erro ao salvar alteração: \(erro.localizedDescription)")
        }
        
    }
    }
