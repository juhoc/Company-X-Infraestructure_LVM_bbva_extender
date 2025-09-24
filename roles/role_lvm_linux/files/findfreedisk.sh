#!/bin/bash
find_free_disks_complete() {
    
    # Obtener todos los discos (excluyendo particiones y LVM)
    lsblk -rn -o NAME,TYPE,SIZE,FSTYPE,MOUNTPOINT | while read name type size fstype mountpoint; do
        # Solo procesar discos físicos
        [[ "$type" == "disk" ]] || continue
        
        device="/dev/$name"
        
        # Excluir disco principal del sistema
        [[ "$device" == "/dev/sda" ]] && continue
        
        # Excluir dispositivos de CD/DVD
        [[ "$name" =~ ^sr[0-9] ]] && continue
        
        # Verificar si tiene particiones
        has_partitions=$(lsblk -rn "$device" | tail -n +2 | wc -l)
        
        if [ "$has_partitions" -eq 0 ]; then
            # No tiene particiones, verificar si tiene filesystem
            if [ -z "$fstype" ]; then
                echo "$device"
            else
                echo "NON_DISK_DETECT"
            fi
        fi
    done
}

find_free_disks_complete