#!/bin/bash
# Enables and disables better maintenance mode on all stores in a domain group
# See https://www.sonassi.com/help/magestack/maintenance-mode

function usage() {
  cat <<EOF
$(basename $0) Usage:
--

    $(basename $0) [-d|-e]

Examples:
--

> Enable maintenance mode

    cd /microcloud/domains/example
    $(basename $0) -e

> Disable maintenance mode

    cd /microcloud/domains/example
    $(basename $0) -d

EOF
exit 0
}

CURRENT_DIR=$(pwd)

read DOMAIN_GROUP < <(echo "${CURRENT_DIR}/" | ack-grep "/microcloud/domains/([^/]+)" --output='$1')
ROOT=/microcloud/domains/$DOMAIN_GROUP/domains

[ ! -d "$ROOT" ] && echo "Error: Domain-group cannot be found" && usage

while getopts ":ed" opt; do
	case $opt in
		e)
			while true; do
				read -p "This will enable maintenance mode for all stores. Are you sure you wish to continue? (y/n) " yn
				case $yn in
					[Yy]* )
						for D in `find ${ROOT}* -maxdepth 1 -mindepth 1 -type d`
						do
							if [ ! -f ${D}/.maintenance.on ]; then
								touch ${D}/.maintenance.on
								echo "  > ${D}"
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
						for D in `find ${ROOT}* -maxdepth 1 -mindepth 1 -type d`
						do
							if [ -f ${D}/.maintenance.on ]; then
								 rm ${D}/.maintenance.on
								 echo "  > ${D}"
							else
								echo "Maintenance flag not found for ${D}."
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
