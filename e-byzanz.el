;;; e-byzanz.el --- summary -*- lexical-binding: t -*-

;; Author: calle
;; Maintainer: calle
;; Version: 0.0.1
;; Package-Requires: (dependencies)
;; Homepage: homepage
;; Keywords: keywords


;; This file is not part of GNU Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.


;;; Commentary:

;; This is a Emacs wrapper for "byzanz - small screencast creator".
;; Created by Benjamine Otte.
;; By calling: M-x byzanz-record it will invoke an interactive with
;; three question:
;; ouput-filename - the file to be created <file>.[gif|webm|flv|ogg,ogv]
;; delay - delay before start recording (seconds)
;; duration - duration of the recording.(seconds)
;; The current selected window will be recorded for the duration
;; of the time.

;;; Code:


(defvar col/output-file "/tmp/output.gif")


(defun col/start-byzanz-process (duration delay x y w h file-name)
  "Start a byzanz process.
DURATION - duration of the process.
DELAY - delay before start.
X - x position on window as pixels.
Y - y position on window as pixels.
W - width of the recording screen.
H - height of the recording screen.
FILE-NAME - output file"
  (let ( (process (start-process "byzanz-process" "*byzanz-output*" "byzanz-record"
                                 "-c"
                                 "--duration" (number-to-string duration)
                                 "--delay" (number-to-string delay)
                                 "-x" (number-to-string x)
                                 "-y" (number-to-string y)
                                 "-w" (number-to-string w)
                                 "-h" (number-to-string h)
                                 file-name
                                 )))

    (set-process-sentinel process (lambda (process event)
                                    (let ((
                                           answ (yes-or-no-p "Open created file? ")))
                                      (when answ
                                        (browse-url-firefox col/output-file)))
                                    (message "Process: %s Event: %s " process event)))))






(defun byzanz-record(output-file delay duration )
  "Start a BYZANZ-RECORD process of a Emacs window.
OUTPUT-FILE - can either be <file>.flv,gif,ogg,ogv or webm
DELAY - delay before start.
DURATION - duration of recording."
    (interactive "FOuput File: \nndelay: \nnDuration: ")
    (let ( (wind-edg (window-absolute-pixel-edges (selected-window)))
           (wind-height (window-pixel-height (selected-window)))
           (wind-width (window-pixel-width (selected-window)))
           )
      (setq col/output-file (expand-file-name output-file))
      (col/start-byzanz-process duration delay
                                (nth 0 wind-edg)
                                (nth 1 wind-edg)
                                wind-width wind-height col/output-file)))


(provide 'e-byzanz)

;;; e-byzanz.el ends here
