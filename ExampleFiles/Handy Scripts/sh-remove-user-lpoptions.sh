#!/bin/bash

if [ -e "$HOME/.lpoptions" ]; then
   rm ~/.lpoptions
   echo "Removing default printer..."
fi

exit 0;
