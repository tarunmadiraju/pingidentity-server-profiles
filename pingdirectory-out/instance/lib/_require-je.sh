#!/bin/sh

# Look for a lib/je.jar or lib/je-*.jar file to be present.  If it isn't found,
# then an error message will be printed. An error message will also be printed
# if multiple files are present.
MISSING_JE=1

if test -f "${INSTANCE_ROOT}/lib/je.jar"
then
  MISSING_JE=0
fi

for FILE in "${INSTANCE_ROOT}"/lib/je-*.jar
do
  if test -f "${FILE}"
  then
    if test ${MISSING_JE} -eq 0
    then
      echo "ERROR: Multiple Berkeley DB Java Editor jar files found."
      exit 1
    fi
    MISSING_JE=0
  fi
done

export MISSING_JE
if test ${MISSING_JE} -eq 1
then
  echo "ERROR:  Berkeley DB Java Edition jar file not found."
  cat "${INSTANCE_ROOT}/lib/downloading-je.txt"
fi

