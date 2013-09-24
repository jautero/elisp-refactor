;;; refactor.el --- Emacs tools for refactoring

;; This software is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This software is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this software; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;; Copyright (C) 2013 Juha Autero, all rights reserved.

(provides 'elisp-refactor)

;; Navigation between different code files/directories
(defcustom srcpathparts '("src" ".cpp") 
  "List of strings that are replaced in source file path." 
  :group 'elisp-refactor)
(defcustom headerpathparts '("src" ".h") 
  "List of strings that are replaced in header file path." 
  :group 'elisp-refactor)
(defcustom buildpathparts '("build")
  "List of strings that are replaced in build directory path."
  :group 'elisp-refactor)

(defun switchpath (path current new)
  "Replace strings in path string that are listed in 'current' with ones listed in 'new'."
  (replace-regexp-in-string 
   (car current) (car new)
   (if (or (null (cdr current)) (null cdr new))
       path
     (switchpath path (cdr current) (cdr new)))))

(defun setpathparts (current new)
  "Set local variables for current and new pathpats"
  (set (make-local-variable 'currentpathparts) current)
  (set (make-local-variable 'newpathparts) new))

(defun switch-between-header-and-code ()
  "Switch between header file and code file buffers. Assumes that currentpathparts and newpathparts are set appropriately."
  (interactive)
  (find-file (switchpath buffer-file-name currentpathparts newpathparts)))

(defun header-file (path)
  (string= (file-name-extension path) "h"))

(defun setpathparts-hook ()
  "Function to set current and new pathpart based on file type."
  (if (header-file buffer-file-name) 
      (setpathparts headerpathparts srcpathparts)
    (setpathparts srcpathparts headerpathparts)))

(add-hook 'c-mode-hook 'setpathparts-hook)

(defun get-builddir ()
  (setpathparts (file-name-directory) buffer-file-name currentpathparts buildpathparts)
