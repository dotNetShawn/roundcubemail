#!/bin/sh

# In 'translator' mode files will contain empty translated texts
# where translation is not available, we'll remove these later

tx --debug pull -a --mode translator

PWD=`dirname "$0"`

do_clean()
{
    echo "Cleaning $1"

    # remove untranslated/empty texts
    perl -pi -e "s/^\\\$labels\[[^]]+\]\s+=\s+'';\n//g" $1
    perl -pi -e "s/^\\\$messages\[[^]]+\]\s+=\s+'';\n//g" $1
    # remove (one-line) comments
    perl -pi -e "s/^\\/\\/[a-z\s]+//g" $1
    # remove empty lines (but not in file header)
    perl -ne 'print if ($. < 21 || length($_) > 1)' $1 > $1.tmp
    mv $1.tmp $1
}

# clean up translation files
for file in $PWD/../program/localization/*/*.inc; do
    do_clean $file
done
for file in $PWD/../plugins/*/localization/*.inc; do
    do_clean $file
done
