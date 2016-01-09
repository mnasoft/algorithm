;;;; algorithm-graph-generic.lisp

(in-package #:algorithm)
;;;;(declaim (optimize (debug 3)))

(defgeneric to-string (obj)
   (:documentation "Прелбразование объекта в строку"))

(defgeneric add-vertex (node-graph) (:documentation "lksjdlfkj"))

(defgeneric insert (part container) (:documentation "Выражает зависимость добавления части в контейнер"))

(defgeneric copy-class-instance(class-object) (:documentation "Выполняет копирование и экземпляра класса"))

(defgeneric switch-time (obj from-state to-tate) (:documentation "Возвращает время преркладки клапана, крана итп из одного состояния в другое"))
