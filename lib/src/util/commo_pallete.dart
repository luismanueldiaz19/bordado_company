import 'package:flutter/material.dart';

const Color colorsAd = Color(0xff2A2638);
const Color colorsRed = Color(0xffB0040C);
const Color colorsRedVino = Color(0xff7A0104);
const Color colorsRedVinoHard = Color(0xff62070C);
const Color colorsRedOpaco = Color(0xff953234);
const Color colorsBlueTurquesa = Color(0xff0E79F2);
const Color colorsBlueDeepHigh = Color(0xff2D71A3);
const Color colorsBlueTurquesaOther = Color(0xff0595F7);
const Color colorsPuppleOpaco = Color(0xff6D386B);
const Color colorsGreenLevel = Color(0xff3A7A40);
const Color colorsGreyWhite = Color(0xffE0DFE5);
const Color colorsGreyGrey = Color.fromARGB(255, 194, 184, 241);
const Color colorsOrange = Color.fromARGB(255, 209, 154, 82);
const Color colorsGreenTablas = Color.fromARGB(255, 18, 205, 99);

const Color ktejidoblue = Color(0xff8282ff);
const Color ktejidoblueOpaco = Color(0xff9a9abe);
const Color ktejidoBlueOcuro = Color(0xff34004d);

const Color ktejidogrey = Color.fromARGB(255, 99, 103, 124);

ButtonStyle styleButton = ButtonStyle(
    backgroundColor:
        WidgetStateProperty.resolveWith((states) => ktejidoBlueOcuro),
    shape: WidgetStateProperty.resolveWith((states) =>
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))));

// 🎨 Colores por Departamento

const Color naranjaPrinter = Color.fromARGB(255, 255, 165, 0); // PRINTER
const Color turquesaSublimado =
    Color.fromARGB(255, 64, 224, 208); // SUBLIMACION
const Color verdeLimonSastreria =
    Color.fromARGB(255, 173, 255, 47); // SASTRERIA
const Color lilaConfeccion = Color.fromARGB(255, 200, 162, 200); // CONFECCION
const Color amarilloBordado = Color.fromARGB(255, 234, 212, 10); // BORDADO
const Color fucsiaSerigrafia = Color.fromARGB(255, 255, 105, 180); // SERIGRAFIA
const Color rojoCostura = Color.fromARGB(255, 255, 76, 76); // COSTURA
const Color moradoDiseno = Color.fromARGB(255, 186, 104, 200); // DISEÑO
