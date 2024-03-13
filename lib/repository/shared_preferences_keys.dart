enum SharedPreferencesKey {
  timer('timer'),
  brightness('brightness'),
  bgColor('bg_color'),
  ;

  const SharedPreferencesKey(this.value);
  final String value;
}
