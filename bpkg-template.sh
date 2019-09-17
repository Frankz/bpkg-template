#!/bin/bash

# function for input()
# @Param string $1
# - Name of variable where save input
# @Param string $2
# - Message in pront
function input () {
  read -p "${2}" "${1}"
}

function bpkg-template () {
  # pedimos el nombre de la app
  # input ${input_var_name} ${message prompt}
  input APP_NAME "Insert name for your App: "
  input LICENSE "Insert kind of License: "
  
  # eso sirve para crear un directorio en el lugar donde estamos, con el nombre "bpkg-$NOMBRE_DE_LA_APP"
  # dentro creamos los archivos que corresponden como base
  mkdir "bpkg-$APP_NAME" 
  cd "bpkg-$APP_NAME" 
  touch example.sh && touch LICENSE && touch Makefile && touch package.json && touch $APP_NAME.sh
  curl -sS -Lo- https://opensource.org/licenses/MIT | grep -A 10  "Begin license text" | grep  -v "Begin license text." | grep -v LicenseText | sed 's/<[^>]*>//g' | sed "s|&lt;YEAR&gt;|$(date +\"%Y\")|g" | sed "s|&lt;COPYRIGHT HOLDER&gt;|\"$(whoami)\"|g" > LICENSE
  


}


## detect if being sourced and
## export if so else execute
## main function with args
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f bpkg-template
else
  bpkg-template "${@}"
fi