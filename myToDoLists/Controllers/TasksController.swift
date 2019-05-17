//
//  TasksController.swift
//  myToDoLists
//
//  Created by Dawit Ayele on 5/5/19.
//  Copyright © 2019 Dawit Ayele. All rights reserved.
//

import UIKit
class TaskController: UITableViewController{
    
    var taskStore: TaskStore!{
        didSet{
            //get data
            
                taskStore.tasks = TasksUtility.fetch() ?? [[Task](), [Task]()]
           
            //Reload table view
            
             tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default){ _ in
            
            // Grab text field text
            guard let name = alertController.textFields?.first?.text else {return}
            //create task
            let newTask = Task(name: name)
            //add task
            self.taskStore.add(newTask, at:0 )
            
            // reload data in tabel view
            let indexPath = IndexPath(row:0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { textField in
            
            textField.placeholder = "Enter task name ..."
            textField.addTarget(self, action:#selector(self.handleTextChanged), for: .editingChanged)
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true )
    }
    @objc private func handleTextChanged(_ sender: UITextField){
        //Grab the alart con...
        
        guard let alertController = presentedViewController as? UIAlertController,
            let addAction = alertController.actions.first,
            let text = sender.text
            else{ return }
        
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
// Mark: - DataSource

extension TaskController{
    
   
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      
        return section == 0 ? "To-Do" : "Done"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskStore.tasks[section].count
    }
  
    
    @available(iOS 2.0, *)
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].name
        return cell
    }

}
// Mark-Deligate
extension TaskController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Determine whterher the task is done
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            guard let isDone  = self.taskStore.tasks[indexPath.section][indexPath.row].isDone else {return}
            
            self.taskStore.removeTask(at: indexPath.row,isDone: isDone)
            
            //reload table view
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        
            
            completionHandler(true)
        }
        
        //Remove the task from apapropriate array
       deleteAction.image = UIImage(named: "delete.png")
        deleteAction.backgroundColor = .red
         return UISwipeActionsConfiguration(actions: [deleteAction])
        
        //indicate that the actio was perfomed
    }
   override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    // Create Contextual Action
    let doneAction = UIContextualAction(style: .normal, title: nil) { (action, sourceView, completionHandler) in
        
        // Toggle Task's isCompleted value - Finished Tasks cannot go back to unfinished
        self.taskStore.tasks[0][indexPath.row].isDone = true
        
        // Remove the task from Unfinished Array
        let doneTask = self.taskStore.removeTask(at: indexPath.row)
        
        // Reload table view for deletion
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        // Add to Finished Tasks
        self.taskStore.add(doneTask, at: 0, isDone: true)
        
        // Reload table view for adding to Finished section
        tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        
  
        
        // Show Action was performed
        completionHandler(true)
    }
    
    doneAction.image = UIImage(named: "done.png")
    doneAction.backgroundColor = .green
    
    // Return Nil if trying to swipe right on Finished Tasks
    return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
}
