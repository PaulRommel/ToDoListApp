//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Pavel Popov on 22.11.2024.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController, UITabBarDelegate, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    private var tasks: [TaskEntity] = []
    private let tableView = UITableView()
    
    // Создаем Tab Bar
    private let tabBar = UITabBar()
    private let addButton = UIButton(type: .system)
    private let tasksLabel = UILabel()
    
    // Переменная для хранения количества задач
    private var tasksCount = 0 {
        didSet {
            updateTasksLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        setupTableView()
        loadTasks()
        
        setupSearch()
        setupTabBar()
        setupAddButton()
        setupTasksLabel()
    }
    
    // Добавлениеи TableView
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        view.addSubview(tableView)
    }
    
    // Загрузка данных в таблицу при первом запуске
    private func loadTasks() {
        let savedTasks = CoreDataManager.shared.fetchTasks()
        
        if savedTasks.isEmpty {
            APIManager.shared.fetchTasks { [weak self] tasks in
                guard let self = self else { return }
                CoreDataManager.shared.saveTasks(tasks)
                self.tasks = CoreDataManager.shared.fetchTasks()
                self.tableView.reloadData()
            }
        } else {
            self.tasks = savedTasks
            tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.textLabel?.textColor = task.completed ? .gray : .white
        cell.backgroundColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let detailsVC = TaskDetailsViewController(task: task)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    // Обновление результатов поиска (UISearchResultsUpdating)
    func updateSearchResults(for searchController: UISearchController) {
        // Здесь можно обработать результаты поиска
        let searchText = searchController.searchBar.text ?? ""
        print("Ищем: \(searchText)")
    }
    
    private func setupSearch(){
        // Настройка UISearchController
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barStyle = .black
        searchController.searchBar.searchTextField.backgroundColor = .darkGray
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.searchTextField.tintColor = .white
        
        // Добавляем поисковую строку в навигационный бар
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - TabBar
    private func setupTabBar(){
        // Настройка Tab Bar
        tabBar.barTintColor = .darkGray
        tabBar.isTranslucent = false
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tabBar)
        
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupAddButton(){
        // Настройка кнопки
        addButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        addButton.tintColor = .yellow
        addButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        tabBar.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor, constant: -16),
            addButton.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 40),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupTasksLabel(){
        // Настройка метки
        tasksLabel.text = "\(tasksCount) Задач"
        tasksLabel.font = .systemFont(ofSize: 16, weight: .bold)
        tasksLabel.textColor = .white
        tasksLabel.textAlignment = .center
        tasksLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tabBar.addSubview(tasksLabel)
        
        NSLayoutConstraint.activate([
            tasksLabel.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            tasksLabel.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor)
        ])
    }
    
    @objc private func addTask(){
        // Добавление задачи
        //tasksCount += 1
        // Показываем Alert для добавления новой задачи
        let alert = UIAlertController(title: "Новая задача", message: "Введите описание задачи", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Описание задачи"
        }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let self = self, let taskText = alert.textFields?.first?.text, !taskText.isEmpty else { return }
            //self.tasks.append(taskText) // Добавляем новую задачу
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func updateTasksLabel() {
        // Обновление текста метки
        tasksLabel.text = "Tasks: \(tasksCount)"
    }
    
}

