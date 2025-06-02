#include <LiquidCrystal.h>
#include <DHT.h>
#include <Servo.h>

// Definición de pines
#define DHTPIN 7
#define DHTTYPE DHT22
#define HEATERPIN 8
#define COOLERPIN 10
#define SERVO_CALOR_PIN 13
#define SERVO_FRIO_PIN 6
#define LED_LUZ_PIN 9

// Pines sensores analógicos
#define LDRPIN A0
#define AIREPIN A1
#define VIENTOPIN A2
#define DIRECCIONPIN A3

DHT dht(DHTPIN, DHTTYPE);
// Pines LCD1602: RS, E, D4, D5, D6, D7
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

Servo servoCalor;
Servo servoFrio;

// These constants should match the photoresistor's "gamma" and "rl10" attributes
const float GAMMA = 0.7;
const float RL10 = 50;

//Constantes para implementar el algoritmo de control de tres posiciones con zona muerta
const float TEMP_OBJETIVO = 25.0;
const float ZONA_MUERTA = 3.0;
float tempAnterior = 0;

void setup() {
  Serial.begin(9600);
  lcd.begin(16, 2);

  dht.begin();
  Serial.println("SENSOR DHT STARTED");

  pinMode(HEATERPIN, OUTPUT);
  pinMode(COOLERPIN, OUTPUT);

  servoCalor.attach(SERVO_CALOR_PIN);
  servoFrio.attach(SERVO_FRIO_PIN);

  pinMode(LED_LUZ_PIN, OUTPUT);

  lcd.print("Estacion Meteo");
  delay(2000);
  lcd.clear();
}

void loop() {

  Serial.println("Reading the DHT sensor...");

  // Lectura de temperatura y humedad
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();

  // Verificar si hay error en la lectura
  if (isnan(temperature) || isnan(humidity)) {
    Serial.println("Error al leer el sensor DHT");
    return;
  }

  float limInferior = TEMP_OBJETIVO - ZONA_MUERTA;
  float limSuperior = TEMP_OBJETIVO + ZONA_MUERTA;

  String estadoTemperatura = "";  // Para mostrar en LCD

  //Comprobar temperatura para mantener a 25º las baterías
  if (temperature < limInferior) {
    digitalWrite(HEATERPIN, HIGH); //Calefactor ON
    servoCalor.write(90);  // abre válvula caliente
    digitalWrite(COOLERPIN, LOW); //Enfriador OFF
    servoFrio.write(0);    // cierra válvula fría
    estadoTemperatura = "Calefactor ON";

    Serial.println("Calefactor: ON");

  } else if (temperature > limSuperior) {
    digitalWrite(HEATERPIN, LOW); //Calefactor OFF
    servoCalor.write(0);    // cierra válvula caliente
    digitalWrite(COOLERPIN, HIGH); //Enfriador ON
    servoFrio.write(90);    // abre válvula fría
    estadoTemperatura = "Enfriador ON";

    Serial.println("Enfriador: ON");

  } else {
    digitalWrite(HEATERPIN, LOW); //Calefactor OFF
    digitalWrite(COOLERPIN, LOW); //Enfriador OFF
    servoCalor.write(0);    // ambas válvulas cerradas
    servoFrio.write(0);
    estadoTemperatura = "Ambos OFF";

    Serial.println("Calefactor: OFF; Enfriador: OFF");
  }

  // Leer sensores analógicos
  int valorLDR = analogRead(LDRPIN);
  int valorAire = analogRead(AIREPIN);
  int valorViento = analogRead(VIENTOPIN);
  int valorDireccion = analogRead(DIRECCIONPIN);

  //Mapeamos el valor del potenciómetro a ángulo (0-180º)
  int angulo = map(valorDireccion, 0, 1023, 0, 180);

  //Mapeamos el valor de la velocidad del viento (0-120km/h)
  int velocidadViento = map(valorViento, 0, 1023, 0, 120);

  // Convert the analog value into lux value:
  float voltage = valorLDR / 1024. * 5;
  float resistance = 1000 * voltage / (1 - voltage / 5);
  float lux = pow(RL10 * 1e3 * pow(10, GAMMA) / resistance, (1 / GAMMA));

  // Convertir lux a brillo PWM (0-255)
  // Cuanto menos lux, mayor brillo
  int brillo = map(lux, 0, 300, 255, 0);

  // Limitar los valores para evitar desbordes
  brillo = constrain(brillo, 0, 255);

  // Aplicar el PWM al LED
  analogWrite(LED_LUZ_PIN, brillo);

  Serial.println("... Sensor readed!");
  Serial.print("Temperature: ");
  Serial.print(temperature);
  Serial.println(" ºC, ");

  Serial.print("Humidity: ");
  Serial.print(humidity);
  Serial.println(" %");

  Serial.print("Luz (LDR): ");
  Serial.print(lux);
  Serial.println(" lux");

  Serial.print("Calidad Aire: ");
  Serial.println(valorAire);

  Serial.print("Velocidad Viento: ");
  Serial.print(velocidadViento);
  Serial.println(" km/h");

  Serial.print("Direccion Viento: ");
  Serial.println(valorDireccion);
  Serial.print("Direccion Viento (°): ");
  Serial.println(angulo);

  Serial.print("Brillo PWM: ");
  Serial.println(brillo);

  Serial.println("==========================\n");

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Temp:");
  lcd.print(temperature, 1);
  lcd.print(" C");
  lcd.setCursor(0, 1);
  lcd.print("Humedad:");
  lcd.print(humidity, 1);
  lcd.print(" %");
  delay(2000);

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Luz:");
  lcd.print(lux, 2);
  lcd.print(" lux");
  lcd.setCursor(0, 1);
  lcd.print("Aire:");
  lcd.print(valorAire);
  delay(2000);

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Viento:");
  lcd.print(velocidadViento);
  lcd.print(" km/h");
  lcd.setCursor(0, 1);
  lcd.print("Dir:");
  lcd.print(angulo);
  lcd.print(" grados");
  delay(2000);

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Temp act:");
  lcd.print(temperature, 1);
  lcd.print(" C");
  lcd.setCursor(0, 1);
  lcd.print("Temp ant:");
  lcd.print(tempAnterior, 1);
  lcd.print(" C");
  delay(3000);

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Estado:");
  lcd.setCursor(0, 1);
  lcd.print(estadoTemperatura);
  delay(3000);

  //Guardamos el valor de la temp para mostrar temp actual y anterior en el LCD
  tempAnterior = temperature;
}
