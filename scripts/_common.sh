#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================
# borrowed here: https://github.com/YunoHost-Apps/vaultwarden_ynh/blob/master/scripts/_common.sh

_download_dex_from_docker() {
    #docker_image="dexidp/dex"
    docker_image="ghcr.io/timas130/dex"
    #debian=$(lsb_release --codename --short)
    #if [[ $debian = "bullseye" ]]; then
    #    docker_version="$(ynh_app_upstream_version)-distroless"
    #elif [[ $debian = "bookworm" ]]; then
    #    docker_version="$(ynh_app_upstream_version)-alpine"
    #fi
    docker_version="sha256:2aef1b55c59b2dc7f5e083486138f3d6e34c6121140618830be80032e998090a"

    docker_arg=""
    # Fixup for armhf
    if [ "$YNH_ARCH" == "armhf" ]; then
        docker_arg="--os_arch_variant=linux/arm/v7"
    fi

    mkdir -p "$install_dir/build"
    ynh_docker_image_extract --dest_dir="$install_dir/build" --image_spec="$docker_image:$docker_version" $docker_arg
    mkdir -p "$install_dir/bin"
    mv "$install_dir/build/usr/local/bin/dex" "$install_dir/bin/"
    mv "$install_dir/build/srv/dex/web/" "$install_dir/web"
    ynh_safe_rm "$install_dir/build"

    chmod 750 "$install_dir"
    chmod -R o-rwx "$install_dir"
    chown -R "$app:$app" "$install_dir"
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

