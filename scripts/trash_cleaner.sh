find /home/dhruv/.local/share/Trash/files/ -type f,d -mtime +15 -print0 | xargs -0 rm -rf
