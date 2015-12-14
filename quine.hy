(setv src "(defn show-sexp [first args]\n  (print (+ \"(\" first \" \" (.join \" \" args) \")\")))\n\n(defn string-string [x]\n  (setv x (.replace x \"\\\\\" \"\\\\\\\\\"))\n  (setv x (.replace x \"\\\"\" \"\\\\\\\"\"))\n  (setv x (.replace x \"\\n\" \"\\\\n\"))\n  (+ \"\\\"\" x \"\\\"\"))\n\n(defclass printer []\n  (defn --init-- [self]\n    (setv self.tasks []))\n\n  (defn --enter-- [self] self)\n\n  (defn --exit-- [self etype evalue tb]\n    (print \"(with [p (printer)]\")\n    (for [[first args] self.tasks]\n      (show-sexp first args))\n    (print \")\"))\n\n  (defn exec-and-print-esc-varname [self name value]\n    (.append self.tasks [\".exec-and-print-esc-varname\"\n                         [\"p\" (string-string name) \"(string-string\" name \")\"]])\n    (print value))\n\n  (defn exec-and-print-varname [self name value]\n    (.append self.tasks [\".exec-and-print-varname\"\n                         [\"p\" (string-string name) name]])\n    (print value))       \n\n  (defn exec-and-print [self &rest args]\n    (setv kwargs {\"end\" \"\"})\n    (.append self.tasks [\".exec-and-print\"\n                         (+ [\"p\"] (list-comp (string-string x) [x args]))])\n    (apply print args kwargs))\n  )\n"
)
(defn show-sexp [first args]
  (print (+ "(" first " " (.join " " args) ")")))

(defn string-string [x]
  (setv x (.replace x "\\" "\\\\"))
  (setv x (.replace x "\"" "\\\""))
  (setv x (.replace x "\n" "\\n"))
  (+ "\"" x "\""))

(defclass printer []
  (defn --init-- [self]
    (setv self.tasks []))

  (defn --enter-- [self] self)

  (defn --exit-- [self etype evalue tb]
    (print "(with [p (printer)]")
    (for [[first args] self.tasks]
      (show-sexp first args))
    (print ")"))

  (defn exec-and-print-esc-varname [self name value]
    (.append self.tasks [".exec-and-print-esc-varname"
                         ["p" (string-string name) "(string-string" name ")"]])
    (print value))

  (defn exec-and-print-varname [self name value]
    (.append self.tasks [".exec-and-print-varname"
                         ["p" (string-string name) name]])
    (print value))       

  (defn exec-and-print [self &rest args]
    (setv kwargs {"end" ""})
    (.append self.tasks [".exec-and-print"
                         (+ ["p"] (list-comp (string-string x) [x args]))])
    (apply print args kwargs))
  )

(with [p (printer)]
(.exec-and-print p "(setv src ")
(.exec-and-print-esc-varname p "src" (string-string src ))
(.exec-and-print p ")\n")
(.exec-and-print-varname p "src" src)
)
