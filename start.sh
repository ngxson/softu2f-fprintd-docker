#!/bin/bash

# Extract the path from the DBUS_SESSION_BUS_ADDRESS variable
path=$(echo $DBUS_SESSION_BUS_ADDRESS | cut -d'=' -f2)

# Get the owner uid and gid of the file
USER_UID=$(stat -c '%u' $path)
USER_GID=$(stat -c '%g' $path)

# Print out the uid and gid
echo "USER_UID: $USER_UID"
echo "USER_GID: $USER_GID"

# Check if the group with the specified GID exists
if ! getent group $USER_GID >/dev/null 2>&1; then
  echo "Group with GID $USER_GID does not exist. Creating the group..."
  sudo groupadd -g $USER_GID $USER

  # Create user
  useradd -u $USER_UID -g $USER_GID -M -N -s /bin/bash $USER
  usermod -aG $USER $USER
fi

# Send notification
# sudo -E -u user -g user notify-send -t 1000 "SoftU2F fprintd started"

# Start server process
export RUST_LOG=debug
mkdir /.socket
chown $USER:$USER /.socket
/app/system-daemon -s /.socket/softu2f.sock &

# Start client process
sleep 1
chmod a+rw /.socket/softu2f.sock
ls -laZ /.socket
/app/user-daemon -s /.socket/softu2f.sock
