#!/usr/bin/env bash
git -P log --summary | grep -e '    ' -e 'commit' -e 'Date:' | sed -e 's/commit /---\n/g' -e 's/Date:   //g' > CHANGELOG

