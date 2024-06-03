setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-addon-sqlsrv
  mkdir -p $TESTDIR
  export PROJNAME=test-addon-sqlsrv
  export DDEV_NON_INTERACTIVE=true
  export DB2_INSTANCE=db2inst1
  export DB2_DATABASE=testdb
  export DB2_HOST=db2
  export DB2_EXTERNAL_PORT=50000
  export DB2_PASSWORD=db
  export DB2_USER=db
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  ddev start -y >/dev/null
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart
  # Checks that the odbc drivers for PHP are installed.
  ddev exec "php -i" | grep "pdo_odbc"
  # Checks db2 connection.
  ddev -s db2 exec "su - ${DB2_INSTANCE} -c 'db2 connect to ${DB2_DATABASE}'" | grep ${DB2_DATABASE}
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get robertromore/ddev-db2 with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get robertromore/ddev-sqlsrv
  ddev restart >/dev/null
  # Checks that the sqlsrv drivers for PHP are installed.
  ddev exec "php -i" | grep "pdo_odbc"
  # Checks db2 connection.
  ddev -s db2 exec "su - ${DB2_INSTANCE} -c 'db2 connect to ${DB2_DATABASE}'" | grep ${DB2_DATABASE}
}