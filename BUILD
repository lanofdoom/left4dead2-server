load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_layer", "container_push")
load("@io_bazel_rules_docker//docker/util:run.bzl", "container_run_and_commit", "container_run_and_extract")

#
# Build Left 4 Dead 2 Layer
#

container_run_and_extract(
    name = "download_left_4_dead_2",
    commands = [
        "sed -i -e's/ main/ main non-free/g' /etc/apt/sources.list",
        "echo steam steam/question select 'I AGREE' | debconf-set-selections",
        "echo steam steam/license note '' | debconf-set-selections",
        "apt update",
        "apt install -y ca-certificates steamcmd",
        "/usr/games/steamcmd +login anonymous +force_install_dir /opt/game +app_update 222860 validate +quit",
        "rm -rf /opt/game/steamapps",
        "chown -R nobody:root /opt/game",
        "tar -czvf /archive.tar.gz /opt/game/",
    ],
    extract_file = "/archive.tar.gz",
    image = "@base_image//image",
)

container_layer(
    name = "left_4_dead_2",
    tars = [
        ":download_left_4_dead_2/archive.tar.gz",
    ],
)

#
# Build Config Layer
#

container_image(
    name = "config_container",
    base = "@base_image//image",
    directory = "/opt/game/left4dead2/cfg",
    files = [
        ":entrypoint.sh",
        ":server.cfg",
    ],
)

container_run_and_extract(
    name = "build_config",
    commands = [
        "chown -R nobody:root /opt",
        "tar -czvf /archive.tar.gz /opt",
    ],
    extract_file = "/archive.tar.gz",
    image = ":config_container.tar",
)

container_layer(
    name = "config_layer",
    tars = [
        ":build_config/archive.tar.gz",
    ],
)

#
# Build Final Image
#

container_image(
    name = "server_image",
    base = "@base_image//image",
    entrypoint = ["/opt/game/left4dead2/cfg/entrypoint.sh"],
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
    layers = [
        ":left_4_dead_2",
        ":config_layer",
    ],
    user = "nobody",
)

container_push(
    name = "push_server_image",
    format = "Docker",
    image = ":server_image",
    registry = "ghcr.io",
    repository = "lanofdoom/left4dead2-server",
    tag = "latest",
)
