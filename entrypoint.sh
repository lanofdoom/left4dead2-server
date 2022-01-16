#!/bin/bash -ue

[ -z "${L4D2_HOST}" ] || echo "${L4D2_HOST}" > /opt/game/left4dead2/host.txt

[ -z "${L4D2_MOTD}" ] || echo "${L4D2_MOTD}" > /opt/game/left4dead2/motd.txt

[ -z "${L4D2_ADMIN}" ] || echo "${L4D2_ADMIN} \"99:z\"" > /opt/game/left4dead2/addons/sourcemod/configs/admins_simple.ini

LD_LIBRARY_PATH="/opt/game:/opt/game/bin:${LD_LIBRARY_PATH:-}" /opt/game/srcds_linux \
    -game left4dead2 \
    -port "$L4D2_PORT" \
    -strictbindport \
    +ip 0.0.0.0 \
    +motd_enabled "$L4D2_MOTD_ENABLED" \
    +map "$L4D2_MAP" \
    +hostname "$L4D2_HOSTNAME" \
    +rcon_password "$RCON_PASSWORD" \
    +sv_password "$L4D2_PASSWORD" \
    +sv_steamgroup "$L4D2_STEAMGROUP"
