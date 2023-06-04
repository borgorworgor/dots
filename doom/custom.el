(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("276c08753eae8e13d7c4f851432b627af58597f2d57b09f790cb782f6f043966" default))
 '(display-battery-mode t)
 '(display-time-mode t)
 '(org-agenda-files
   '("~/Documents/general/contacts.org.gpg" "~/Documents/general/Archive/tasks.org" "~/Documents/general/journal/" "~/Documents/general/lifeStuff/"))
 '(org-cite-global-bibliography '("~/Documents/biblio/papers.bib"))
 '(org-image-actual-width 640)
 '(org-journal-dir "/home/arlo/Documents/general/journal/")
 '(org-roam-capture-templates
   '(("d" "default" plain "%?" :target
      (file+head "${slug}.org" ":PROPERTIES:
:CAPTURED: %U
:END:
#+title: ${title}
")
      :unnarrowed t)
     ("s" "School" plain "%?" :if-new
      (file+head "${slug}.org" ":PROPERTIES:
:CAPTURED: %U
:subject: %^{Subject}
:teacher: %^{Teacher}
:topic: %^{Topic}
:category: %^{Category}
:END:
#+filetags: %^{Subject}
#+title: ${title}
* Definition:
")
      :unnarrowed t)))
 '(org-roam-directory "~/Documents/general/")
 '(org-todo-keywords
   '((sequence "TODO(t)" "PROJ(p)" "EXAM(e)" "LOOP(r)" "STRT(s)" "WAIT(w)" "HOLD(h)" "IDEA(i)" "|" "DONE(d)" "KILL(k)")
     (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")
     (sequence "|" "OKAY(o)" "YES(y)" "NO(n)")
     (sequence "WANT(W)" "READING(R)" "READ(b)")))
 '(ranger-override-dired 'ranger))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:slant italic))))
 '(font-lock-keyword-face ((t (:slant italic)))))
