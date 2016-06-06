#!/bin/bash
# Enables and disables maintenance mode on all stores in a domain group

ROOT=/microcloud/domains/exampl/domains/

while getopts ":ed" opt; do
	case $opt in
		e)
			while true; do
				read -p "This will enable maintenance mode for all stores. Are you sure you wish to continue? (y/n) " yn
				case $yn in
					[Yy]* )
						for D in `find ${ROOT}* -maxdepth 0 -type d`
						do
							if [ -f ${D}/http/_maintenance.flag ];
							then
								mv ${D}/http/_maintenance.flag ${D}/http/maintenance.flag
							else
								echo "Maintenance flag not found in ${D}/http."
							fi
						done
						echo "Maintenance mode enabled." >&2; break;;
					[Nn]*  ) exit;;
					* ) echo "Please answer y or n.";;
				esac
			done
		;;
		d)
			while true; do
				read -p "This will disable maintenance mode for all stores. Are you sure you wish to continue? (y/n) " yn
				case $yn in
					[Yy]* )
						for D in `find ${ROOT}* -maxdepth 0 -type d`
						do
							if [ -f ${D}/http/maintenance.flag ];
							then
								 mv ${D}/http/maintenance.flag ${D}/http/_maintenance.flag
							else
								echo "Maintenance flag not found in ${D}/http."
							fi
						done
						echo "Maintenance mode disabled." >&2; break;;
					[Nn]*  ) exit;;
					* ) echo "Please answer y or n.";;
				esac
			done
		;;
		\?)
			echo "invalid option: -$OPTARG" >&2
			echo "USAGE: Flip maintenance mode on all stores with the -e -d (enable disable) flags." >&2
		;;
	esac
done
