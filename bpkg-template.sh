#!/bin/bash

# function for input()
# @Param string $1
# - Name of variable where save input
# @Param string $2
# - Message in promt
function input () {
  #read -t 10 -p "${2}" "${1}"
  read -p "${2}" "${1}"
}

function bpkg-template () {
  # pedimos el nombre de la app
  # input ${input_var_name} ${message prompt}
  WORKDIR=$(pwd)
  input APP_NAME "Insert name for your App: "
  echo "Create app in $WORKDIR/$APP_NAME"
  input LICENSE "Insert kind of License: "
  
  # eso sirve para crear un directorio en el lugar donde estamos, con el nombre "$NOMBRE_DE_LA_APP"
  # dentro creamos los archivos que corresponden como base
  cd $WORKDIR
  mkdir $WORKDIR"/${APP_NAME}"
  cd $WORKDIR"/${APP_NAME}" 
  # create files
  touch example.sh && touch LICENSE && touch Makefile && touch package.json && touch $APP_NAME.sh
  ################
  # fill LICENSE
  ################
  curl -sS -Lo- https://opensource.org/licenses/MIT | grep -A 10  "Begin license text" | grep  -v "Begin license text." | grep -v LicenseText | sed 's/<[^>]*>//g' | sed "s|&lt;YEAR&gt;|$(date +\"%Y\")|g" | sed "s|&lt;COPYRIGHT HOLDER&gt;|\"$(whoami)\"|g" > LICENSE

  ################
  # fill Makefile
  ################

  cat > Makefile <</EOF
BIN ?= ${APP_NAME}
PREFIX ?= /usr/local

install:
        cp ${APP_NAME}.sh \$(PREFIX)/bin/\$(BIN)

uninstall:
        rm -f \$(PREFIX)/bin/\$(BIN)

example.sh:
        ./example.sh

.PHONY: example.sh

/EOF


  ################
  # fill the ${APP_NAME}.sh
  ################
  cat > ${APP_NAME}.sh <<EOF
function ${APP_NAME} () {
  echo "# Test line to delete"
  echo $@
  
}

## detect if being sourced and
## export if so else execute
## main function with args
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f ${APP_NAME}
else
  ${APP_NAME} "${@}"
fi
EOF

  ################
  # fill the package.json
  ################
  cat > package.json <<EOF
{
  "name": "${APP_NAME}",
  "version": "0.0.1",
  "description": "Add a custom message here about your ${APP_NAME}",
  "scripts": [ "${APP_NAME}.sh" ],
  "install": "make install"
}
EOF

  ################
  # fill the package.json
  ################
  cat > README.md <<EOF
# ${APP_NAME}
Add custom message description about your ${APP_NAME} app.
EOF

}


## detect if being sourced and
## export if so else execute
## main function with args
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f bpkg-template "\$@"
else
  bpkg-template "\${@}"
fi
