#!/bin/bash

# Aquatime ASCII Logo
cat << "EOF"
                                  ./##########/.                                
                           ######/              /#####(                         
                      *###(                            (###*                    
                   /##(                                    (##(                 
                .##(                                          (##.              
              ,##,                                              *##.            
             ##/                                                  *##           
           *##                                    .(((((/           ##(         
          (#(                                   /((((((((((          /#(        
         (#(             ,(((((((((((((((,     *((((((((((#(          (#/       
         ##          (/              (((((((,  .((((((((###(           ##.      
        ##.        *(//////////////(((((((((((,  (########.            ,#(      
        ##    /(((((((((((//////////////########,                       ##      
        ## ((((((#########((((//////////////(#######(,                  ##      
        ############################((///////////**//((########(*******(##      
        ########(##########(((((((((((((((((//////////*********/((((((((##      
        .###(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((##*      
         ###(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((#(       
          ###(((((((((((((((((((((((((((((((((((((((((((((((((((((((((##        
           (##((((((((((((((((((((((((((((((((((((((((((((((((((((((##(         
            ,##(((((((((((((((((((((((((((((((((((((((((((((((((/((##*          
              (##(((((((((((((((((((((((((((((((/((//////////////##(            
                (##((((((((((/(///////////////////////////////(##/              
                   ###(////////////////////////////////////(###                 
                      (###(/////////////////////////////###(                    
                          /####(///////////////*//#####/                        
                                ./(############(/.                              
                                                                                

EOF

# Exit-Funktion für Bereinigung
exit_script() {
    echo "Skript abgebrochen. Bereinigung wird durchgeführt..."

    # Unmount aller gemounteten Laufwerke
    unmount_drive "e-share"
    unmount_drive "share"

    # Beenden aller laufenden Hintergrundprozesse (optional)
    kill_background_processes

    echo "Bereinigung abgeschlossen."
    exit 1
}

# Trap CTRL+C, CTRL+Z und Fehler
trap exit_script SIGINT SIGTSTP ERR

# Funktion, um ein Laufwerk zu unmounten
unmount_drive() {
    local mount_point=~/"$1"
    if mount | grep -q "$mount_point"; then
        echo "Unmounting $mount_point..."
        umount "$mount_point"
    fi
}

# Funktion zum Beenden aller Hintergrundprozesse (optional)
kill_background_processes() {
    # Beenden aller sshfs-Prozesse
    # Dies kann je nach Bedarf angepasst werden
    killall sshfs 2>/dev/null
}

# Überprüfung, ob FUSE installiert ist
check_fuse_installed() {
    if [ -f "/usr/local/bin/sshfs" ]; then
        echo "FUSE ist installiert."
        return 0 # Erfolg
    else
        echo "FUSE ist nicht installiert. Bitte installieren Sie es von: https://osxfuse.github.io/"
        return 1 # Fehler
    fi
}

# Überprüfung aufrufen
if ! check_fuse_installed; then
    exit_script
fi

# Funktion, um ein Laufwerk zu mounten
mount_drive() {
    local mount_point=~/"$1"
    local remote_path="/mnt/$1"
    local volname="$2"
    local server=$3

    if [ ! -d "$mount_point" ]; then
        echo "Erstelle Verzeichnis: $mount_point"
        mkdir -p "$mount_point"
    else
        if mount | grep -q "$mount_point"; then
            echo "Das Laufwerk $mount_point ist bereits gemountet. Remounting..."
            umount "$mount_point"
        fi
    fi

    if /usr/local/bin/sshfs -o volname="$volname" "$server":"$remote_path" "$mount_point"; then
        echo "Laufwerk erfolgreich gemountet: $mount_point"
    else
        echo "Fehler beim Mounten des Laufwerks: $mount_point"
    fi
}

# Auswahl des Servers
read -p "Möchten Sie die Laufwerke über das Intranet (i) oder das Internet (e) mounten? (i/e): " server_choice
case $server_choice in
    i) server="aquatime@192.168.10";;
    e) server="aquatime@server.aquatime.ch";;
    *) echo "Ungültige Eingabe"; exit 1;;
esac

# Mounten der Laufwerke
mount_drive "e-share" "e-Share" "$server"
mount_drive "d-data" "d-Data" "$server"
mount_drive "backup" "backup" "$server"
mount_drive "share" "Share" "$server"

echo "Alle Mount-Vorgänge abgeschlossen."
