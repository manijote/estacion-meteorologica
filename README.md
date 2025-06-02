
# Actividad 2: Sistema de control y actuación en función del clima

## 📋 Descripción

Esta actividad de integración basada en la medición, control, actuación y presentación del clima tiene como objetivo diseñar e implementar un sistema embebido con instrumentación programable que mida variables climáticas y actúe automáticamente para mantener las condiciones óptimas del entorno de las baterías.

Esta estación meteorológica integrada basada en Arduino está diseñada para:
- Medir variables climáticas: temperatura, humedad, luminosidad, calidad del aire, velocidad y dirección del viento.

- Ejecutar acciones de control y actuación: mediante resistencia calefactora, sistema de enfriamiento, servomotores y luces LED de señalización.

- Visualizar la información en un HMI local (pantalla LCD) de manera clara y ergonómica.

Para ello, utiliza un algoritmo de control de tres posiciones con zona muerta para mantener la temperatura del sistema de baterías en 25 °C, con una tolerancia de ±3 °C. El sistema actúa automáticamente si la temperatura está fuera de este rango.

## 📦 Componentes utilizados (Bill of Materials - BOM)

| Componente                | Cantidad |
|:--------------------------|:-----------|
| Arduino UNO                | 1         |
| Sensor DHT22               | 1         |
| Sensor LDR + resistencia 1kΩ | 1         |
| 3 Potenciómetros (simuladores) | 3       |
| Servomotores (SG90 o genérico) | 2       |
| LED (calefactor)           | 1         |
| LED (enfriador)            | 1         |
| LED (iluminación PWM)      | 1         |
| Pantalla LCD 1602 + potenciómetro contraste | 1 |
| Resistencias 220Ω          | 3         |
| Protoboards                | 3         |

## 📝 Diagrama de conexiones

Diagrama del circuito:

![](images\diagram.jpg)

## Código fuente

El código está desarrollado en Arduino. Utiliza las siguientes bibliotecas:

- LiquidCrystal.h: para controlar la pantalla LCD.

- DHT.h: para lectura del sensor de temperatura y humedad.

- Servo.h: para manejar servomotores.

## 📑 Funcionamiento

### 📌 Control de temperatura

Se mantiene una temperatura objetivo de **25ºC** con una **zona muerta de ±3ºC**:
- Si la temperatura es menor de 22ºC: activa calefactor y abre válvula de fluido caliente.
- Si supera 28ºC: activa enfriador y abre válvula de fluido frío.
- Entre 22ºC y 28ºC: sistema en reposo.

### 📌 Control de iluminación

- Un LED controlado por **PWM** regula su intensidad según la luz ambiental medida por el LDR.
- A menor luz, mayor intensidad del LED.

### 📌 Visualización

El sistema muestra en la pantalla LCD:
- Temperatura actual y anterior
- Humedad
- Nivel de iluminación en lux
- Calidad de aire (simulada)
- Velocidad y dirección del viento
- Estado de calefactor y enfriador

## 📄 Proyecto completo 

[wokwi](https://wokwi.com/projects/432553899538797569)

## 📦 Vídeo simulación

[video](https://drive.google.com/file/d/1dekGNJ-VacTxhRSojd129GxvyvKLgZPR/view?usp=sharing)

## 📌 Autores

- Gonzalo Caballero Lora
- Marta González Alonso
- Álvaro Lax Gómez
- Álvaro Rangel Belmonte 

Asignatura: **Equipos e Instrumentación Electrónica**  
Curso 2024/2025