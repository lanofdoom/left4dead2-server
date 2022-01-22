# LAN of DOOM Left 4 Dead 2 Server
Docker image for a private, preconfigured private Left 4 Dead 2 server
as used by the LAN of DOOM.

# Installation
Run ``docker pull ghcr.io/lanofdoom/left4dead2-server:latest``

# Environmental Variables
``L4D2_HOST`` The host to display on the MOTD screen.

``L4D2_HOSTNAME`` The name of the server as listed in Valve's server browser.

``L4D2_PASSWORD`` The password users must enter in order to join the server.

``L4D2_MAP`` The first map to run on the server. ``c8m1_apartment`` by default.

``L4D2_MOTD`` The MOTD to use for the server.

``L4D2_MOTD_ENABLED`` Controls if the MOTD should be displayed when a user joins
the server. ``0`` by default.

``L4D2_PORT`` The port to use for the server. ``27015`` by default.

``L4D2_STEAMGROUP`` The Steam group to that will see the server displayed on the
Left 4 Dead 2 launch screen.

``RCON_PASSWORD`` The rcon password for the server.