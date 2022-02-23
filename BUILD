load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_layer", "container_push")
load("@io_bazel_rules_docker//docker/package_managers:download_pkgs.bzl", "download_pkgs")
load("@io_bazel_rules_docker//docker/package_managers:install_pkgs.bzl", "install_pkgs")
load("@com_github_lanofdoom_steamcmd//:defs.bzl", "steam_depot_layer")

#
# Left 4 Dead 2 Layer
#

steam_depot_layer(
    name = "left_4_dead_2",
    app = "222860",
    directory = "/opt/game",
)

#
# Config Layer
#

container_layer(
    name = "config",
    directory = "/opt/game/left4dead2/cfg",
    files = [
        ":server.cfg",
    ],
)

#
# Base Image
#

download_pkgs(
    name = "server_deps",
    image_tar = "@base_image//image",
    packages = [
        "ca-certificates",
        "libcurl4",
    ],
)

install_pkgs(
    name = "server_base",
    image_tar = "@base_image//image",
    installables_tar = ":server_deps.tar",
    installation_cleanup_commands = "rm -rf /var/lib/apt/lists/*",
    output_image_name = "server_base",
)

#
# Build Final Image
#

container_image(
    name = "server_image",
    base = ":server_base",
    entrypoint = ["/entrypoint.sh"],
    env = {
        "L4D2_HOST": "",
        "L4D2_HOSTNAME": "",
        "L4D2_MAP": "c8m1_apartment",
        "L4D2_MOTD": "",
        "L4D2_MOTD_ENABLED": "0",
        "L4D2_PASSWORD": "",
        "L4D2_PORT": "27015",
        "L4D2_STEAMGROUP": "",
        "RCON_PASSWORD": "",
    },
    files = [
        ":entrypoint.sh",
    ],
    layers = [
        ":left_4_dead_2",
        ":config",
    ],
    symlinks = {
        "/root/.steam/sdk32/steamclient.so": "/opt/game/bin/steamclient.so"
    },
)

container_push(
    name = "push_server_image",
    format = "Docker",
    image = ":server_image",
    registry = "ghcr.io",
    repository = "lanofdoom/left4dead2-server",
    tag = "latest",
)
