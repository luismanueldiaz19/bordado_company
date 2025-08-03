double getSize(double sizeOriginal) {
  // print('sizeOriginal $sizeOriginal');
  double? sizeGot = sizeOriginal;
  if (sizeOriginal < 300 || sizeOriginal < 600) {
    return sizeGot = sizeGot * 0.90;
  }
  if (sizeOriginal > 601 || sizeOriginal < 1500) {
    return sizeGot * 0.40;
  }
  if (sizeOriginal > 0 || sizeOriginal < 300) {
    return sizeGot * 0.50;
  }
  // print(sizeGot);
  return sizeGot * 0.60;
}
