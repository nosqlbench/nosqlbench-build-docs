#!/bin/bash

# This script takes a zip file named exported_docs.zip, containing exported
# markdown from the main NoSQLBench build as input.
# This zip file is produced by running "nb5 export-docs"
#
# Each top-level directory in this zip file correspondes to a specific subsection
# in the docs site structure.
#
# The exported docs are unzipped directly into site/content/reference/
#

#set -x
unzip -l exported_docs.zip
unzip exported_docs.zip -o -d site/content/reference/

