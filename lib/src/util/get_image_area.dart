String getImageAreas(idAreas) {
  String image = 'assets/logo_app.png';
  switch (idAreas) {
    case 1:
      image = 'assets/sublimacion.jpg';
      break;
    case 2:
      image = 'assets/design.jpg';
      break;
    case 3:
      image = 'assets/serigrafia.jpg';
      break;
    case 4:
      image = 'assets/satreria.jpg';
      break;
    case 5:
      image = 'assets/bordado.jpg';
      break;
    case 6:
      image = 'assets/confeccion.jpg';
      break;
    case 7:
      image = 'assets/almacen.jpg';
      break;
    case 8:
      image = 'assets/reception.png';
      break;
    case 9:
      image = 'assets/redes.png';
      break;
    case 10:
      image = 'assets/serigrafia.png';
      break;
    case 12:
      image = 'assets/plancha_empaque.png';
      break;
    case 13:
      image = 'assets/arte_bordado.png';
      break;
    case 14:
      image = 'assets/arte_diseno.png';
      break;
  }

  return image;
}
