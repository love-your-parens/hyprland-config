#!/bin/env bb

(ns screenshot (:require [babashka.process :refer [sh]]
                         [babashka.fs :as fs]
                         [clojure.string :as string]))

(defn non-blank-string
  [s]
  (when (not (string/blank? s)) s))

(def ok? (comp zero? :exit))

(def pictures-dir (or (non-blank-string (let [cmd (sh "xdg-user-dir" "PICTURES")]
                                          (when (ok? cmd) (string/trim (:out cmd)))))
                      (non-blank-string (System/getenv "HOME"))))

(when (nil? pictures-dir) (throw (Exception. "Can't resolve a valid path for screenshots!")))

(def filename (fs/path pictures-dir (str "Screenshot_"
                                         (.format (java.time.format.DateTimeFormatter/ofPattern "YYYYMMdd_HHmmss")
                                                  (java.time.LocalDateTime/now))
                                         ".png")))

(let [cmd (sh "grim" filename)]
  (when (ok? cmd)
    (let [notify-cmd (sh "notify-send"
                         "-i" filename
                         "-a" "Screenshot"
                         "-u" "low" ; idem
                         "-A" "open=Open file"
                         ;; Don't block forever. NOTE "open" will no longer work after timeout.
                         "-t" "10000"
                         (str "Saved to: " filename))]
      (when (and (ok? notify-cmd)
                 (= "open" (string/trim (:out notify-cmd))))
        (babashka.process/process "xdg-open" filename)))))
