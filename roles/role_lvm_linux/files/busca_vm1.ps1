param(
    [Parameter(Mandatory=$true)]
    [string]$vmName
)

$PSStyle.OutputRendering = 'PlainText'
$env:NO_COLOR = "1"
$env:TERM = "dumb"

# Configurar logging
$logFile = "vm_search_$(Get-Date -Format 'yyyyMMdd_HHmmss')_$vmName.log"
Start-Transcript -Path $logFile -Append

# --- Configuración (modifica estos valores) ---
[string[]]$vCenterServers = @(
    "150.100.188.84"
#    "10.10.10.11",
#    "10.10.10.12"
) # Reemplaza con los FQDNs o IPs de tus vCenters.
$vcUser = "cb\bvmwiat2"
$vcPass = "6sIQd.sPa995#99W" # Considera usar Get-Credential para mayor seguridad

# --- Proceso del script ---
Write-Host "Conectando a los vCenters..."
try {
    Connect-VIServer -Server $vCenterServers -User $vcUser -Password $vcPass -ErrorAction Stop
    Write-Host "Conexión a vCenters establecida."
}
catch {
    Write-Error "Error al conectar a uno o más vCenters: $($_.Exception.Message)"
    exit 1
}

Write-Host "Buscando la VM '$vmName'..."
$vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue

if ($null -ne $vm) {
    # La VM fue encontrada en al menos un vCenter.
    Write-Host "--- VM '$vmName' ENCONTRADA ---"

    # Itera sobre cada VM encontrada (puede haber duplicados por nombre en diferentes vCenters)
    foreach ($foundVm in $vm) {
        # Extrae el nombre del vCenter de la sesión
        $vcName = ([uri]$foundVm.ExtensionData.Client.ServiceUrl).Host

        Write-Host "Nombre de la VM: $($foundVm.Name)"
        Write-Host "Estado: $($foundVm.PowerState)"
        Write-Host "Host ESXi: $($foundVm.Host.Name)"
        Write-Host "Servidor vCenter: $vcName"
        Write-Host ""

        Write-Host "--- Información de los Datastores ---"
        try {
            $datastores = Get-Datastore -VM $foundVm
            foreach ($ds in $datastores) {
                $capacidadGB = [math]::Round($ds.CapacityGB, 2)
                $espacioLibreGB = [math]::Round($ds.FreeSpaceGB, 2)
                Write-Host "Datastore: $($ds.Name)"
                Write-Host "Capacidad: $($capacidadGB) GB"
                Write-Host "Espacio Libre: $($espacioLibreGB) GB"
                Write-Host "Parametros:$espacioLibreGB,$vcName $($foundVm.Name) $($ds.Name) Thin"
                Write-Host "--------------------------------------"
            }
        }
        catch {
            Write-Warning "No se pudo obtener la información del datastore para $($foundVm.Name): $($_.Exception.Message)"
        }
    }
}
else {
    Write-Error "No se encontró la máquina virtual '$vmName' en ninguno de los vCenters conectados."
}

# --- Limpieza (desconectar de vCenters) ---
Write-Host "`nDesconectando de todos los vCenters..."
try {
    Disconnect-VIServer -Confirm:$false -ErrorAction SilentlyContinue
    Write-Host "Desconexión completa."
}
catch {
    Write-Warning "Error al desconectar: $($_.Exception.Message)"
}

Write-Host

Stop-Transcript
