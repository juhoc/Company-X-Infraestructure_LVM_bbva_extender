# **README**

## **LVM Linux**

## **Introducción**

El proyecto "LVM Linux" permite realizar el formateo de un dispositivo de disco para convertirlo en un:

|Volumen Fisico | Grupo de Volumenes | Volumenes Logicos
|:---------------|:------------------:|:----------------:|
|  Formato al /dev/sd(b-z) | crear VG's /dev/sd(b-z)   | Con los VG's se crean los LV's y se monatan los FS's  |

## **Distribuciones soportadas**

- Linux Red Hat
- Linux SuSE

## **Uso**

Para hacer uso de este proyecto en Ansible, siga las siguientes indicaciones:

- Ingresar al portal de Ansible
- Buscar la plantilla bajo el nombre "bvm_jobtemplate_lvm_linux"
- Ejecutar la plantilla

O accediendo a la siguiente liga: [Playbook](https://ansible-tower.eu4.cacf.kyndryl.net/#/templates/job_template/133905/details)

## **Instrucciones**

1. Click en el boton de Ejecutar (Launch si esta en ingles).
2. Otros avisos:
   - En el campo "Limite", colocar los equipos a intervenir, formato valido (host1.* host2.* host3.* hostN.*)
- Clic en Siguiente.
3. Encuesta:
   - Ingrese ticket Helix: 
      - Ingresar CRQ o INC + 12 Digitos, Ej: CRQ00000000000
   - Seleccionar la Tarea: 
      - LVM_Total
   - Seleccionar el Grupo de Volumenes:
      - VGAPPS
   - Escribir el Nombre del Volumen Logico
      - Escribir el nombre Volumen Logivo, Ej: LVJAVA
   - Ingresar el tamaño del Volumen Logico:
      - Ingresar el tamaño del Volumen Logico, Ej: 5
   - Escribir el punto de montura para el Voilume Logico
      - Escribir el punto de montura del Volumen Logico, Ej: /javactm
   - Seleccionar el formato para el Volumen Logioco
      - xfs
      - ext4
- Clic en siguiente
4. Vista previa:
   - Ejecutar (Launch si esta en ingles).

## **Resultados**

Los resultados que se esperan visualizar en la salida del Playbook son los siguientes:

- Ejecucion correcta del Playbook

## **Desarrollador(es)**

Julio C. Hoyos Corredor

Alfredo Gonzalez Alonso
