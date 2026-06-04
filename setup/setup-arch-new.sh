#!/usr/bin/env bash
sleep 1

export SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# 1. Repo Preflight
preflight="$repo_path/setup/preflight-$distro.sh"
if [ -f "$preflight" ]; then
	info "Running preflight script for $distro..."
	source "$preflight"
fi

# 2. Dependencies
if [ ! -d "$dep_dir" ]; then
	warn "Dependency folder not found at: $dep_dir"
	return 1
fi

[ -f "$dep_dir/packages" ] && process_package_file "$dep_dir/packages"
distro_pkgs="$dep_dir/packages-$distro"
[ -f "$distro_pkgs" ] && process_package_file "$distro_pkgs"
_installAllPackages
_finishMessage

# 3. Repo Post-installation
postflight="$repo_path/setup/post-$distro.sh"
if [ -f "$postflight" ]; then
	info "Running post-installation script for $distro..."
	source "$postflight"
fi

# 4. User-specific Post-installation
user_post="$user_config_dir/post.sh"
if [ -f "$user_post" ]; then
	info "Running user-specific post-installation script for $profile_id..."
	source "$user_post"
fi
_installAllPackages
_finishMessage
