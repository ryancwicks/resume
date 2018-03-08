# resume

## Tools Setup

Needs pdflatex to typeset:

````
sudo apt-get install texlive-latex-base
sudo apt-get install texlive-fonts-recommended
tlmgr install ragged2e
````

## Generate PDF

````
latex resume.tex
````

## Decrypting the Cover Letter Signature 

Do this before running latex on the cover letter.

````
gpg mysignature.pdf.gpg
````
