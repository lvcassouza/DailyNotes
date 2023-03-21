//
//  ListarAnotacoes.swift
//  Notas Diarias
//
//  Created by Lucas Souza on 21/09/22.
//

import UIKit
import CoreData

class ListarAnotacoes: UITableViewController {
    
    var anotacoes: [NSManagedObject] = []
    var context: NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let indice = indexPath.row
        let anotacao = self.anotacoes[indice]
        self.performSegue(withIdentifier: "verAnotacao", sender: anotacao)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verAnotacao"{
            
            let viewDestino = segue.destination as! anotacao
            viewDestino.anotacao = sender as? NSManagedObject
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.recuperarAnotacoes()
    }
    
    func recuperarAnotacoes() {
        
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Anotacao")
        let ordenacao = NSSortDescriptor(key: "data", ascending: false)
        requisicao.sortDescriptors = [ordenacao]
        
        do {
            let anotacoesRecuperadas = try context.fetch(requisicao)
            
            self.anotacoes = anotacoesRecuperadas as! [NSManagedObject]
            
            self.tableView.reloadData()
            
        } catch let erro {
            print("Erro ao recuperar anotacoes: \(erro.localizedDescription)")
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.anotacoes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        let anotacao = self.anotacoes[indexPath.row]
        let textoRecuperado = anotacao.value(forKey: "texto")
        let dataRecuperada = anotacao.value(forKey: "data")
        
        //formatar a data
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy hh:mm"
        
        let novaData = dateFormater.string(from: dataRecuperada as! Date)
        
        celula.textLabel?.text = textoRecuperado as? String
        celula.detailTextLabel?.text = novaData
        
        return celula
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete{
            
            let indice = indexPath.row
            let anotacao = self.anotacoes[indice]
            
            self.context.delete(anotacao)
            self.anotacoes.remove(at: indice)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            do {
                try self.context.save()
            } catch let erro {
                print("Erro ao remover: \(erro)")
            }
        }
        
    }
}
