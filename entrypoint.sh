#!/bin/bash -ue

# Install srcds required certificates
apt-get update && apt-get install -y ca-certificates

# Set host name and MOTD
[ -z "${L4D2_HOST}" ] || echo "${L4D2_HOST}" > /opt/game/left4dead2/host.txt
[ -z "${L4D2_MOTD}" ] || echo "${L4D2_MOTD}" > /opt/game/left4dead2/motd.txt

# Update server config file
cp /opt/game/left4dead2/cfg/templates/server.cfg /opt/game/left4dead2/cfg/server.cfg
echo "// Added by entrypoint.sh" >> /opt/game/left4dead2/cfg/server.cfg
echo "hostname \"$L4D2_HOSTNAME\"" >> /opt/game/left4dead2/cfg/server.cfg

# Mark srcds_linux as executable
chmod +x /opt/game/srcds_linux

# Call srcds_linux instead of srcds_run to avoid restart logic
LD_LIBRARY_PATH="/opt/game:/opt/game/bin:${LD_LIBRARY_PATH:-}" /opt/game/srcds_linux \
    -game left4dead2 \
    -port "$L4D2_PORT" \
    -strictbindport \
    -usercon \
    +ip 0.0.0.0 \
    +motd_enabled "$L4D2_MOTD_ENABLED" \
    +map "$L4D2_MAP" \
    +rcon_password "$RCON_PASSWORD" \
    +sv_password "$L4D2_PASSWORD" \
    +sv_steamgroup "$L4D2_STEAMGROUP"
