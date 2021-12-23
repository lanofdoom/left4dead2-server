load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_layer", "container_push")
load("@io_bazel_rules_docker//docker/package_managers:download_pkgs.bzl", "download_pkgs")
load("@io_bazel_rules_docker//docker/package_managers:install_pkgs.bzl", "install_pkgs")
load("@io_bazel_rules_docker//docker/util:run.bzl", "container_run_and_commit", "container_run_and_extract")

#
# Build Server Base Image
#

container_run_and_extract(
    name = "enable_i386_sources",
    commands = [
        "dpkg --add-architecture i386",
    ],
    extract_file = "/var/lib/dpkg/arch",
    image = "@container_base//image",
)

container_image(
    name = "container_base_with_i386_packages",
    base = "@container_base//image",
    directory = "/var/lib/dpkg",
    files = [
        ":enable_i386_sources/var/lib/dpkg/arch",
    ],
)

download_pkgs(
    name = "server_deps",
    image_tar = ":container_base_with_i386_packages.tar",
    packages = [
        "lib32gcc-s1",
    ],
)

install_pkgs(
    name = "server_base",
    image_tar = ":container_base_with_i386_packages.tar",
    installables_tar = ":server_deps.tar",
    installation_cleanup_commands = "rm -rf /var/lib/apt/lists/*",
    output_image_name = "server_base",
)

#
# Build Left 4 Dead 2 Layer
#

container_run_and_commit(
    name = "prepare_steamcmd_repo",
    commands = [
        "sed -i -e's/ main/ main non-free/g' /etc/apt/sources.list",
        "echo steam steam/question select 'I AGREE' | debconf-set-selections",
        "echo steam steam/license note '' | debconf-set-selections",
    ],
    image = ":server_base.tar",
)

download_pkgs(
    name = "steamcmd_deps",
    image_tar = ":prepare_steamcmd_repo_commit.tar",
    packages = [
        "ca-certificates:i386",
        "steamcmd:i386",
    ],
)

install_pkgs(
    name = "steamcmd_base",
    image_tar = ":prepare_steamcmd_repo_commit.tar",
    installables_tar = ":steamcmd_deps.tar",
    installation_cleanup_commands = "rm -rf /var/lib/apt/lists/*",
    output_image_name = "steamcmd_base",
)

container_run_and_extract(
    name = "download_left_4_dead_2",
    commands = [
        "/usr/games/steamcmd +login anonymous +force_install_dir /opt/game +app_update 222860 validate +quit",
        "rm -rf /opt/game/steamapps",
        "chown -R nobody:root /opt/game",
        "tar -czvf /archive.tar.gz /opt/game/",
    ],
    extract_file = "/archive.tar.gz",
    image = ":steamcmd_base.tar",
)

container_layer(
    name = "left_4_dead_2",
    tars = [
        ":download_left_4_dead_2/archive.tar.gz",
    ],
)

#
# Build Final Image
#

container_image(
    name = "server_image",
    base = ":server_base",
    directory = "/opt/game",
    entrypoint = ["/opt/game/entrypoint.sh"],
    env = {
        "L4D2_HOSTNAME": "",
        "L4D2_MAP": "c8m1_apartment",
        "L4D2_MOTD": "",
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
