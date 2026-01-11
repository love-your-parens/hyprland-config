#!/bin/env bb

(def icon-theme (str (first *command-line-args*)))

(def home (System/getenv "HOME"))
(when-not home
  (throw (Exception. "Could not establish the path to the home directory!")))

(def kdeglobals (str home "/.config/kdeglobals"))
(when-not (fs/exists? kdeglobals)
  (throw (Exception. (str kdeglobals " does not exist, aborting."))))

(fs/copy kdeglobals (str kdeglobals ".kde")
         {:replace-existing true :copy-attributes true})

(def sections
  (let [lines (line-seq (io/reader kdeglobals))
        [pre [mid-head & mid+post]] (split-with #(not (str/starts-with? % "[Icons]")) lines)
        [mid post] (split-with #(not (str/starts-with? % "[")) mid+post)]
    [pre (cons mid-head mid) post]))

(def output
  (let [[s1 s2 s3] sections
        replacement (str "Theme=" icon-theme)
        s2' (map #(if (str/starts-with? % "Theme=") replacement %) s2)]
    (concat s1 s2' s3)))

(with-open [w (io/writer kdeglobals)]
  (doseq [line output]
    (doto w (.write line) (.write "\n"))))
