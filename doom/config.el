;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; org-agenda-files '("~/Documents/agenda.org"
;;                    "~/Documents/School/RevisionTimetable.org")

(setq org-image-actual-width (/ (display-pixel-width) 10))

(set-register ?a (cons 'file (concat org-directory "general/lifeStuff/agenda.org")))


;; Org
(after! org
  :config
  (require 'org)
  (setq org-directory "~/Documents/"
        org-ellipsis " ↝ "
        org-pretty-entities t
        org-fold-core-style 'overlays
        org-superstar-special-todo-items t
        org-agenda-include-diary t
        org-log-done 'time
        org-log-into-drawer 'time))

; org-roam setup
(after! org-roam
  :config
  (require 'org-roam)
  (setq org-roam-directory "~/Documents/general"
        org-roam-dailies-capture-templates
        '(("d" "default"
           entry "* %<%I:%M %p>: \n%?"
           :if-new (file+head "%<%Y-%m-%d>.org.gpg" "#+title: %<%Y-%m-%d>\n")))
        org-roam-dailies-directory "~/Documents/general/journal/")
        (add-to-list 'display-buffer-alist
             '("\\*org-roam\\*"
               (display-buffer-in-side-window)
               (side . right)
               (slot . 0)
               (window-width . 0.24)
               (window-parameters . ((no-other-window . t)
                                     (no-delete-other-windows . t))))))

(setq epa-file-encrypt-to "arlo.hicks@pm.me")

;; (add-to-list 'display-buffer-alist
;;              '("\\*org-roam\\*"
;;                (display-buffer-in-direction)
;;                (direction . right)
;;                (window-width . 0.33)
;;                (window-height . fit-window-to-buffer)))

;; Org-roam-bibtex
(use-package! org-roam-bibtex
  :after org-roam
  :config
  (require 'org-ref))

;; Org-ref
(use-package! org-ref
  :init
  (require 'bibtex)
  (setq bibtex-autokey-year-length 4
	bibtex-autokey-name-year-separator "-"
	bibtex-autokey-year-title-separator "-"
	bibtex-autokey-titleword-separator "-"
	bibtex-autokey-titlewords 2
	bibtex-autokey-titlewords-stretch 1
	bibtex-autokey-titleword-length 5
        org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f")))

(setq bibtex-dialect 'biblatex)

;; ivy-bibtex
(use-package! ivy-bibtex
  :init
  (setq bibtex-completion-bibliography '("~/Documents/biblio/books.bib"
                                         "~/Documents/biblio/papers.bib")
        bibtex-completion-notes-path "~/Documents/biblio/notes/"
	bibtex-completion-library-path '("~/Documents/biblio/bibtex-pdfs/")
	bibtex-completion-notes-template-multiple-files "* ${author-or-editor}, ${title}, ${journal}, (${year}) :${=type=}: \n\nSee [[cite:&${=key=}]]\n"
	bibtex-completion-additional-search-fields '(keywords)
	bibtex-completion-display-formats
	'((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
	  (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
	  (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	  (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	  (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))
	bibtex-completion-pdf-open-function
	(lambda (fpath)
	  (call-process "open" nil 0 nil fpath))))

(use-package! org-ref-ivy
  :init
  (setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
        org-ref-insert-cite-function 'org-ref-cite-insert-ivy
        org-ref-insert-label-function 'org-ref-insert-label-link
        org-ref-insert-ref-function 'org-ref-insert-ref-link
        org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body))))

;; (after! org-journal
;;   :config
;;   (require 'org-crypt)
;;   (setq org-journal-dir '"~/Documents/Journal/"
;;         org-journal-file-type 'weekly
;;         org-journal-date-format "%A, %d %B %Y"
;;         org-journal-encrypt-journal't))

;;      Org roam ui
(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;; Org-protocol
(server-start)
(require 'org-protocol)

(setq org-capture-templates
      `(
        ("b" "Book" entry (file+headline "~/Documents/general/lifeStuff/book.org" "2022")
         "* TODO %?\nSCHEDULED: %T\n:PROPERTIES:\n:style: habit\n:author: %^{Author}\n:year: %^{Year}\n:page: %^{Current Page}\n:length: %^{Total Pages}\n:logging: DONE(!) lognotedone\n:END:\n%U")

        ("t" "Todo" entry (file "~/Documents/general/lifeStuff/agenda.org")
         "* TODO %?\n:PROPERTIES:\n:CAPTURED: %U\n:END:%i" :empty-lines 1)

        ("T" "Todo + file link" entry (file "~/Documents/general/lifeStuff/agenda.org")
         "* TODO %?\n:PROPERTIES:\n:CAPTURED: %U\n:FILE: file:%F\n:END:%i" :empty-lines 1)

        ("f" "Flashcard" entry (file+headline "~/Documents/general/biology.org" "Flashcards")
         "*  %?\n:PROPERTIES:\n:ANKI_DECK: %U\n:FILE: file:%F\n:END:%i" :empty-lines 1)

        ;; ("s" "School" entry (file+headline "~/Documents/general/lifeStuff/agenda.org" "School Agenda")
        ;;  "* TODO %? :school:\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n%i" :empty-lines 1)

        ("p" "Paper" entry (file+headline "~/Documents/general/papers.org" "Data:")
         "* %U\n:PROPERTIES:\n:date: %U\n:source: %^{source}\n:topic: %^{topic}\n:marks: %^{marks}\n:total: %^{total marks}\n:END:\n%?" :empty-lines 1)

        ("c" "Contact" entry (file "~/Documents/general/contacts.org.gpg")
         "* %(Contact name)\n:PROPERTIES:\n:address: %^{Address}\n:birthday: %^{yyyy-mm-dd}\n:email: %(Email)\n:anniversary: %^{yyyy-mm-dd}\n:occupation: %^{Job}\n:note: %^{NOTE}\n:END:" "Template for org-contacts." :empty-lines 1)

        ("p" "Protocol" entry (file+headline ,"~/Documents/general/lifeStuff/ReadWatchLater.org.gpg" "To-read:")
         "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
        ("L" "Protocol Link" entry (file+headline ,"~/Documents/general/lifeStuff/ReadWatchLater.org.gpg" "To-read:")
         "* [[%:link][%:description]] \n:PROPERTIES:\n:CAPTURED: %U\n:END:\n%?")
        ))

;; Org-habit
;; (use-package! org-habit
;;   :after org
;;   :config
;;   (setq org-habit-following-days 7
;;         org-habit-preceding-days 35
;;         org-habit-show-habits t)  )

(use-package! org-super-agenda
  :after org-super-agenda
  :config
  (setq org-super-agenda-groups '(
                                  ;; (:name "Personal"
                                  ;;        :habit t
                                  ;;        :order 9)
                                  ;; (:name "Today"  ; Optionally specify section name
                                  ;;        :time-grid t
                                  ;;        :date today
                                  ;;        :order 0)  ; Items that appear on the time grid
                                  (:order-multi (0
                                                 (:name "Test"
                                                  :tag "test")))
                                  (:order-multi (1
                                                 (:name "Maths"
                                                  :tag "maths")
                                                 (:name "Biology"
                                                  :tag "biology")
                                                 (:name "Chemistry"
                                                  :tag "chemistry")))

                                  (:name "Clubs"
                                   :tag "club"
                                   :order 3)

                                  (:name "General"
                                   ;; :todo "TODO"
                                   :time-grid t
                                   :order 5)

                                  (:name "Books to read"
                                   :and (:todo ("WANT" "READING"))
                                   :order 8)
                                  ;; (:discard (:anything t))

                                  (:name "Miscellaneous"
                                   :and (:scheduled nil :deadline nil)
                                   :order 9)
                                  )))
  ;; (org-agenda nil "a"))
(org-super-agenda-mode)

(setq org-agenda-custom-commands
      '(("cc" "Clubs"
         ((org-ql-block '(and (tags "club")))
          (agenda)))
        ("cg" "Important Stuff"
         ((org-ql-block '(and (tags "test")))))))

(setq org-agenda-sorting-strategy
      '((agenda time-up habit-up priority-down category-keep)
        (todo   priority-down category-keep)
        (tags   priority-down category-keep)
        (search category-keep)))

(defun calculate-effort (marks-achieved total-marks)
  (interactive)
  (let ((/ (* marks-achieved 100.0) total-marks))
    (if (> effort 100)
        100
      (* effort 100))))

(defun add-exam ()
  (interactive)
  (let ((subject (read-string "Enter exam subject: "))
        (topic (read-string "Enter exam topic: "))
        (marks-achieved (string-to-number (read-string "Enter marks achieved: ")))
        (total-marks (string-to-number (read-string "Enter total marks: "))))
    (find-file "exam-data.org")
    (goto-char (point-min))
    (if (search-forward-regexp (concat "^* " subject "$") nil t)
        (progn
          (org-narrow-to-subtree)
          (if (search-forward-regexp (concat "^** " topic "$") nil t)
              (progn
                (org-set-property "effort" (number-to-string (calculate-effort marks-achieved total-marks)))
                (widen))
            (progn
              (org-insert-subheading nil)
              (insert topic)
              (org-set-property "effort" (number-to-string (calculate-effort marks-achieved total-marks)))
              (widen)))
          (message "Exam data added successfully."))
      (progn
        (goto-char (point-max))
        (org-insert-heading)
        (insert subject)
        (org-insert-subheading nil)
        (insert topic)
        (org-set-property "effort" (number-to-string (calculate-effort marks-achieved total-marks)))
        (message "Exam data added successfully.")))))

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name ""
      user-mail-address "")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; ((setq doom-theme 'doom-tomorrow-night)
;; (setq doom-theme 'doom-snazzy)
;; (use-package-hook! doom-themes
;;   :pre-config
;;   (remove-hook 'doom-load-theme-hook #'doom-themes-org-config))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open Documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq display-line-numbers-type 'relative)

(setq doom-theme 'doom-one
      doom-font (font-spec :family "RobotoMono Nerd Font Mono" :size 15)
     doom-variable-pitch-font (font-spec :family "RobotoMono Nerd Font Mono" :size 15))

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))
;;(setq custom-theme-directory "~/.doom.d/themes/")
;;(load-theme 'doom-nord-theme.el)

;; language tool setup
(after! langtool
  :config
  (require 'langtool)
  (setq langtool-bin "/usr/bin/languagetool"
        langtool-default-language "en-GB"))

;; Treemacs
(after! treemacs
  :ensure t
  :config
  (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
        treemacs-deferred-git-apply-delay        0.5
        treemacs-directory-name-transformer      #'identity
        treemacs-display-in-side-window          t
        treemacs-eldoc-display                   'simple
        treemacs-file-event-delay                5000
        treemacs-file-extension-regex            treemacs-last-period-regex-value
        treemacs-file-follow-delay               0.2
        treemacs-file-name-transformer           #'identity
        treemacs-follow-after-init               t
        treemacs-expand-after-init               t
        treemacs-find-workspace-method           'find-for-file-or-pick-first
        treemacs-git-command-pipe                ""
        treemacs-goto-tag-strategy               'refetch-index
        treemacs-header-scroll-indicators        '(nil . "^^^^^^")
        treemacs-hide-dot-git-directory          t
        treemacs-indentation                     2
        treemacs-indentation-string              " "
        treemacs-is-never-other-window           nil
        treemacs-max-git-entries                 5000
        treemacs-missing-project-action          'ask
        treemacs-move-forward-on-expand          nil
        treemacs-no-png-images                   nil
        treemacs-no-delete-other-windows         t
        treemacs-project-follow-cleanup          nil
        treemacs-persist-file                    "~/.emacs.d/modules/ui/treemacs/treemacs-persist"
        treemacs-position                        'left
        treemacs-read-string-input               'from-child-frame
        treemacs-recenter-distance               0.1
        treemacs-recenter-after-file-follow      nil
        treemacs-recenter-after-tag-follow       nil
        treemacs-recenter-after-project-jump     'always
        treemacs-recenter-after-project-expand   'on-distance
        treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
        treemacs-show-cursor                     nil
        treemacs-show-hidden-files               t
        treemacs-silent-filewatch                nil
        treemacs-silent-refresh                  nil
        treemacs-sorting                         'alphabetic-asc
        treemacs-select-when-already-in-treemacs 'move-back
        treemacs-space-between-root-nodes        t
        treemacs-tag-follow-cleanup              t
        treemacs-tag-follow-delay                1.5
        treemacs-text-scale                      nil
        treemacs-user-mode-line-format           nil
        treemacs-user-header-line-format         nil
        treemacs-wide-toggle-width               70
        treemacs-width                           35
        treemacs-width-increment                 1
        treemacs-width-is-initially-locked       t
        treemacs-workspace-switch-cleanup        nil))
;; treemacs-follow-mode t
;; treemacs-filewatch-mode t))

;; Calendar
;; Month
(use-package! calendar
  :init
  :config
  (require 'calendar)
  (setq calendar-month-name-array
        ["janvier" "février" "mars"     "avril"   "mai"      "juin"
         "juillet"    "aout"   "septembre" "octobre" "novembre" "décembre"]
        calendar-day-name-array
        ["dimanche" "lundi" "mardi" "mercredi" "jeudi" "vendredi" "samedi"]
        calendar-week-start-day 1))

(require 'calfw)
(require 'calfw-org)
(defun open-my-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "Green"))))

(after! org-gcal
  :config
  (setq org-gcal-client-id "270350628842-3fmpu5kn8ee2q0110e42a2mgsblen6hp.apps.googleusercontent.com"
      org-gcal-client-secret "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"
      org-gcal-fetch-file-alist '(("goeagle.hero@gmail.com" .  "~/Documents/general/lifeStuff/agenda.org")
                                  ("3a583e5c5a02c73301ff0401e411268631175ea0bcd083b634b35ca672811c1d@group.calendar.google.com" . "~/Documents/general/timetable.org"))
      plstore-cache-passphrase-for-symmetric-encryption t))

;; Visual-column-fill
(after! visual-fill-column
  :config
  (setq-default visual-fill-column-center-text t))

;; Tabs
(after! centaur-tabs
  :config
  (setq centaur-tabs-style "wave"
        centaur-tabs-height 30
        centaur-tabs-set-icons t
        centaur-tabs-set-modified-marker t
        centaur-tabs-set-bar nil
        x-underline-at-descent-line t
        centaur-tabs-adjust-buffer-order t)

  (defun centaur-tabs-hide-tab (x)
    "Do no to show buffer X in tabs."
    (let ((name (format "%s" x)))
      (or
       ;; Current window is not dedicated window.
       (window-dedicated-p (selected-window))

       ;; Buffer name not match below blacklist.
       (string-prefix-p "*epc" name)
       (string-prefix-p "*helm" name)
       (string-prefix-p "*Helm" name)
       (string-prefix-p "*Compile-Log*" name)
       (string-prefix-p "*lsp" name)
       (string-prefix-p "*company" name)
       (string-prefix-p "*Flycheck" name)
       (string-prefix-p "*tramp" name)
       (string-prefix-p " *Mini" name)
       (string-prefix-p "*help" name)
       (string-prefix-p "*straight" name)
       (string-prefix-p " *temp" name)
       (string-prefix-p "*Help" name)
       (string-prefix-p "*mybuf" name)

       ;; Is not magit buffer.
       (and (string-prefix-p "magit" name)
	    (not (file-name-extension name)))
       ))))

(after! deft
  :config
  (setq deft-extensions '("org")
        deft-directory "~/Documents/general"
        deft-recursive t
        deft-use-filename-as-title t))

;; KEYBINDS
(map! :leader
      (:prefix-map ("e" . "extra")
       :desc "Open Calendar" "o" #'cfw:open-org-calendar
       :desc "Org-ql view" "v" #'org-ql-view
       :desc "Org-ql Search" "s" #'org-ql-search
       (:prefix ("t" . "transclusion")
        :desc "Add" "a" #'org-transclusion-add
        :desc "Remove" "r" #'org-transclusion-deactivate
        :desc "Open source" "o" #'org-transclusion-open-source
        :desc "Refresh source" "f" #'org-transclusion-refresh
        :desc "Start live sync" "s" #'org-transclusion-live-sync-start
        :desc "End live sync" "e" #'org-transclusion-live-sync-exit
        )))

;; Disable evil-mode in local buffer with F12
(global-set-key (kbd "<XF86RFKill>") 'evil-local-mode)

(setq! hl-todo-keyword-faces
       '(("WANT"        . "#b467f9")
         ("READ"        . "#2be3fc")
         ("READING"     . "#ff886a")))

;; Dired
(use-package! dired
  :config
  (ranger-override-dired-mode t))

;; Doom-modeline
(after! doom-modeline
  :config
  (setq doom-modeline--battery-status t
        doom-modeline-major-mode-icon t
        doom-modeline-enable-word-count t))

;; Enable vertico
;; (use-package vertico
;;   :init
;;   (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  ;; )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

(after! orderless
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package! citar
  :bind (("C-c b" . citar-insert-citation)
         :map minibuffer-local-map
         ("M-b" . citar-insert-preset))
  :custom
  (citar-bibliography '("~/Documents/biblio/papers.bib")))
(setq citar-symbols
      `((file ,(all-the-icons-faicon "file-o" :face 'all-the-icons-green :v-adjust -0.1) . " ")
        (note ,(all-the-icons-material "speaker_notes" :face 'all-the-icons-blue :v-adjust -0.3) . " ")
        (link ,(all-the-icons-octicon "link" :face 'all-the-icons-orange :v-adjust 0.01) . " ")))
(setq citar-symbol-separator "  ")

(use-package! chatgpt
  :defer t
  :config
  (unless (boundp 'python-interpreter)
    (defvaralias 'python-interpreter 'python-shell-interpreter))
  (setq chatgpt-repo-path (expand-file-name "straight/repos/ChatGPT.el/" doom-local-dir))
  (set-popup-rule! (regexp-quote "*ChatGPT*")
    :side 'bottom :size .5 :ttl nil :quit t :modeline nil)
  :bind ("C-c q" . chatgpt-query))
