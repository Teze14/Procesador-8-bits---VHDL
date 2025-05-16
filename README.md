# 🧠 Microprocesador de 8 bits en VHDL – Proyecto en DE10-Lite
Este proyecto consiste en el diseño, implementación y validación de un microprocesador de 8 bits completamente funcional desarrollado en VHDL y desplegado en la tarjeta DE10-Lite de Intel. El sistema simula una arquitectura tipo Von Neumann con instrucciones básicas de carga, almacenamiento, operaciones aritméticas, lógicas y control de flujo.

![image](https://github.com/user-attachments/assets/420fc236-c968-4d70-88b4-145fce4de277)

# 📦 Estructura del Proyecto
El procesador está organizado jerárquicamente en los siguientes módulos principales:

CPU: Unidad central de procesamiento, encargada de coordinar el data_path y control_unit.

data_path: Contiene registros internos, buses de datos, la ALU de 8 bits y el sistema de direccionamiento (PC, MAR, IR).

control_unit: Implementa una máquina de estados finitos que decodifica instrucciones y genera señales de control.

ALU_1bit y ALU_8bits: Realizan operaciones aritméticas y lógicas a nivel de bit y byte.

memoria: Módulo intermedio que conecta mem_prog, mem_datos, puertos de entrada y puertos de salida.

mem_prog: Memoria ROM que contiene el programa de instrucciones.

mem_datos: Memoria RAM para almacenamiento temporal.

puertos_salida: Registro de salida para mostrar resultados en LEDs u otras interfaces.

divisor_F: Divisor de frecuencia para desacoplar la velocidad del reloj de la FPGA.

# 🔁 Flujo General
El PC envía una dirección de instrucción a mem_prog.

La instrucción se carga en IR y es decodificada por control_unit.

Según la instrucción, se generan señales para leer/escribir datos desde memoria o ejecutar operaciones en la ALU.

Los resultados pueden almacenarse, usarse en otras instrucciones, o enviarse a un puerto de salida.

# 🛠️ Plataforma
Lenguaje: VHDL

Software: Quartus Prime Lite Edition 18.1

Plataforma: DE10-Lite (Intel FPGA)

# 🚀 Funcionalidades Soportadas
Instrucciones tipo: LOAD, STORE, ADD, SUB, AND, OR, XOR, INC, DEC, NOT

Instrucciones de salto condicional e incondicional (JMP, JZ, JN, JC, etc.)

Acceso a puertos de entrada y salida mapeados en direcciones específicas.

Modo de operación paso a paso con divisor de frecuencia.
