#!/bin/sh

for f in `find _doxygen/xml -name "group__level__*.xml"` ; do
	./_doxygen.rb $f api
done
