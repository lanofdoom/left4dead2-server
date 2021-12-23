#!/bin/bash -ue

[ -z "${L4D2_MOTD}" ] || echo "${L4D2_MOTD}" > /opt/game/l4d2/motd.txt

/opt/game/srcds_run \
    -game l4d2 \
    -port "$L4D2_PORT" \
    -strictbindport \
    -usercon \
    +ip 0.0.0.0 \
    +map "$L4D2_MAP" \
    +hostname "$L4D2_HOSTNAME" \
    +rcon_password "$RCON_PASSWORD" \
    +sv_password "$L4D2_PASSWORD" \
    +sv_steamgroup "$L4D2_STEAMGROUP"
